f"""
Enterprise Kubernetes Cluster Health Checker

Author: Sindu Shree K
Project: Enterprise Cloud Platform
"""

from kubernetes import client, config
from kubernetes.client.rest import ApiException
from datetime import datetime
import os
import time
import sys
# ==========================================================
# Script Start Time
# ==========================================================

START_TIME = time.time()

# ==========================================================
# Load Kubernetes Configuration
# ==========================================================

config.load_kube_config()

# ==========================================================
# Kubernetes API Clients
# ==========================================================

core_v1 = client.CoreV1Api()
apps_v1 = client.AppsV1Api()
networking_v1 = client.NetworkingV1Api()
autoscaling_v2 = client.AutoscalingV2Api()
version_api = client.VersionApi()

# ==========================================================
# Global Variables
# ==========================================================

REPORT_TIME = datetime.now()

issues = []
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

REPORT_DIR = os.path.join(BASE_DIR, "reports")

os.makedirs(REPORT_DIR, exist_ok=True)

REPORT_FILE = os.path.join(
    REPORT_DIR,
    f"cluster_health_{REPORT_TIME.strftime('%Y%m%d_%H%M%S')}.txt"
)

# ==========================================================
# Helper Functions
# ==========================================================

def print_title(title):
    print("\n" + "=" * 70)
    print(title.center(70))
    print("=" * 70)


def print_section(title):
    print("\n" + "-" * 70)
    print(title)
    print("-" * 70)


def add_issue(resource_type, namespace, resource_name, reason):
    issues.append(
        {
            "resource": resource_type,
            "namespace": namespace,
            "name": resource_name,
            "reason": reason,
        }
    )
 # ==========================================================
# Dual Output (Terminal + Report File)
# ==========================================================

class DualOutput:

    def __init__(self, filename):
        self.terminal = sys.stdout
        self.log = open(filename, "a", encoding="utf-8")

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)

    def flush(self):
        self.terminal.flush()
        self.log.flush()



# ==========================================================
# Cluster Information
# ==========================================================

def cluster_information():

    print_title("ENTERPRISE KUBERNETES HEALTH REPORT")
    
    try:

        version = version_api.get_code()

        contexts, active_context = config.list_kube_config_contexts()

        cluster_name = active_context["context"]["cluster"]

        context_name = active_context["name"]

        print(f"Generated At       : {REPORT_TIME.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"Current Context    : {context_name}")
        print(f"Cluster Name       : {cluster_name}")
        print(f"Kubernetes Version : {version.git_version}")

    except Exception as e:

        print(f"Unable to fetch cluster information : {e}")


# ==========================================================
# Node Health
# ==========================================================

def node_health():

    print_section("Node Health")

    nodes = core_v1.list_node().items

    ready_nodes = 0
    not_ready_nodes = 0

    for node in nodes:

        node_name = node.metadata.name

        ready = False

        internal_ip = "N/A"

        kubelet_version = node.status.node_info.kubelet_version

        for address in node.status.addresses:

            if address.type == "InternalIP":

                internal_ip = address.address

        for condition in node.status.conditions:

            if condition.type == "Ready":

                if condition.status == "True":

                    ready = True

        if ready:

            ready_nodes += 1

            status = "Ready"

            icon = "✅"

        else:

            not_ready_nodes += 1

            status = "Not Ready"

            icon = "❌"

            add_issue(
                "Node",
                "-",
                node_name,
                "Node Not Ready"
            )

        print(f"""
{icon} Node Name          : {node_name}
   Status             : {status}
   Internal IP        : {internal_ip}
   Kubernetes Version : {kubelet_version}
""")

    print("-" * 70)

    print(f"Total Nodes      : {len(nodes)}")
    print(f"Ready Nodes      : {ready_nodes}")
    print(f"Not Ready Nodes  : {not_ready_nodes}")

    return ready_nodes, not_ready_nodes
# ==========================================================
# Namespace Summary
# ==========================================================

def namespace_summary():

    print_section("Namespace Summary")

    namespaces = core_v1.list_namespace().items

    for namespace in namespaces:
        print(f"📁 {namespace.metadata.name}")

    print("-" * 70)
    print(f"Total Namespaces : {len(namespaces)}")

    return len(namespaces)


# ==========================================================
# Pod Health
# ==========================================================

def pod_health():

    print_section("Pod Health")

    pods = core_v1.list_pod_for_all_namespaces().items

    running = 0
    pending = 0
    failed = 0
    succeeded = 0
    unknown = 0

    crashloop = 0
    imagepull = 0
    errimagepull = 0
    oomkilled = 0
    evicted = 0

    for pod in pods:

        namespace = pod.metadata.namespace
        pod_name = pod.metadata.name

        phase = pod.status.phase

        if phase == "Running":
            running += 1

        elif phase == "Pending":
            pending += 1

            add_issue(
                "Pod",
                namespace,
                pod_name,
                "Pending"
            )

        elif phase == "Failed":
            failed += 1

            add_issue(
                "Pod",
                namespace,
                pod_name,
                "Failed"
            )

        elif phase == "Succeeded":
            succeeded += 1

        else:
            unknown += 1

        if pod.status.container_statuses is None:
            continue

        for container in pod.status.container_statuses:

            state = container.state

            # Waiting State
            if state.waiting:

                reason = state.waiting.reason

                if reason == "CrashLoopBackOff":

                    crashloop += 1

                    add_issue(
                        "Pod",
                        namespace,
                        pod_name,
                        "CrashLoopBackOff"
                    )

                elif reason == "ImagePullBackOff":

                    imagepull += 1

                    add_issue(
                        "Pod",
                        namespace,
                        pod_name,
                        "ImagePullBackOff"
                    )

                elif reason == "ErrImagePull":

                    errimagepull += 1

                    add_issue(
                        "Pod",
                        namespace,
                        pod_name,
                        "ErrImagePull"
                    )

                elif reason == "CreateContainerConfigError":

                    add_issue(
                        "Pod",
                        namespace,
                        pod_name,
                        "CreateContainerConfigError"
                    )

                elif reason == "CreateContainerError":

                    add_issue(
                        "Pod",
                        namespace,
                        pod_name,
                        "CreateContainerError"
                    )

            # Terminated State
            if state.terminated:

                reason = state.terminated.reason

                if reason == "OOMKilled":

                    oomkilled += 1

                    add_issue(
                        "Pod",
                        namespace,
                        pod_name,
                        "OOMKilled"
                    )

                elif reason == "Evicted":

                    evicted += 1

                    add_issue(
                        "Pod",
                        namespace,
                        pod_name,
                        "Evicted"
                    )

    print(f"Total Pods          : {len(pods)}")
    print(f"Running Pods        : {running}")
    print(f"Pending Pods        : {pending}")
    print(f"Failed Pods         : {failed}")
    print(f"Succeeded Pods      : {succeeded}")
    print(f"Unknown Pods        : {unknown}")

    print("\nDetected Pod Issues")
    print("-" * 70)

    if crashloop > 0:
        print(f"❌ CrashLoopBackOff : {crashloop}")

    if imagepull > 0:
        print(f"❌ ImagePullBackOff : {imagepull}")

    if errimagepull > 0:
        print(f"❌ ErrImagePull     : {errimagepull}")

    if oomkilled > 0:
        print(f"❌ OOMKilled        : {oomkilled}")

    if evicted > 0:
        print(f"❌ Evicted Pods     : {evicted}")

    if (
        crashloop == 0
        and imagepull == 0
        and errimagepull == 0
        and oomkilled == 0
        and evicted == 0
    ):
        print("✅ No pod issues detected.")

    print("-" * 70)

    return {
        "running": running,
        "pending": pending,
        "failed": failed,
        "crashloop": crashloop,
        "imagepull": imagepull,
        "oomkilled": oomkilled,
        "evicted": evicted,
    }
# ==========================================================
# Deployment Health
# ==========================================================

def deployment_health():

    print_section("Deployment Health")

    deployments = apps_v1.list_deployment_for_all_namespaces().items

    unhealthy = 0

    for deploy in deployments:

        namespace = deploy.metadata.namespace
        name = deploy.metadata.name

        desired = deploy.spec.replicas or 0
        available = deploy.status.available_replicas or 0

        if desired == available:

            print(f"✅ {namespace}/{name} ({available}/{desired})")

        else:

            unhealthy += 1

            print(f"❌ {namespace}/{name} ({available}/{desired})")

            add_issue(
                "Deployment",
                namespace,
                name,
                f"Available Replicas {available}/{desired}"
            )

    print("-" * 70)
    print(f"Total Deployments : {len(deployments)}")
    print(f"Healthy           : {len(deployments)-unhealthy}")
    print(f"Unhealthy         : {unhealthy}")

    return unhealthy
# ==========================================================
# Service Summary
# ==========================================================

def service_summary():

    print_section("Service Summary")

    services = core_v1.list_service_for_all_namespaces().items

    for svc in services:

        print(
            f"✅ {svc.metadata.namespace}/{svc.metadata.name}"
            f" ({svc.spec.type})"
        )

    print("-" * 70)
    print(f"Total Services : {len(services)}")

    return len(services)
# ==========================================================
# Persistent Volumes
# ==========================================================

def persistent_volumes():

    print_section("Persistent Volumes")

    pvs = core_v1.list_persistent_volume().items

    for pv in pvs:

        print(
            f"📦 {pv.metadata.name} "
            f"({pv.status.phase})"
        )

    print("-" * 70)
    print(f"Total PVs : {len(pvs)}")

    return len(pvs)
# ==========================================================
# Persistent Volume Claims
# ==========================================================

def persistent_volume_claims():

    print_section("Persistent Volume Claims")

    pvcs = core_v1.list_persistent_volume_claim_for_all_namespaces().items

    for pvc in pvcs:

        print(
            f"📁 {pvc.metadata.namespace}/{pvc.metadata.name}"
            f" ({pvc.status.phase})"
        )

    print("-" * 70)
    print(f"Total PVCs : {len(pvcs)}")

    return len(pvcs)
# ==========================================================
# StatefulSets
# ==========================================================

def statefulsets():

    print_section("StatefulSets")

    sts = apps_v1.list_stateful_set_for_all_namespaces().items

    for item in sts:

        print(
            f"✅ {item.metadata.namespace}/{item.metadata.name}"
        )

    print("-" * 70)
    print(f"Total StatefulSets : {len(sts)}")

    return len(sts)
# ==========================================================
# DaemonSets
# ==========================================================

def daemonsets():

    print_section("DaemonSets")

    daemonsets = apps_v1.list_daemon_set_for_all_namespaces().items

    for ds in daemonsets:

        print(
            f"✅ {ds.metadata.namespace}/{ds.metadata.name}"
        )

    print("-" * 70)
    print(f"Total DaemonSets : {len(daemonsets)}")

    return len(daemonsets)
# ==========================================================
# Horizontal Pod Autoscalers
# ==========================================================

def hpa_health():

    print_section("Horizontal Pod Autoscalers")

    try:

        hpas = autoscaling_v2.list_horizontal_pod_autoscaler_for_all_namespaces().items

        if len(hpas) == 0:
            print("No HPAs found.")
            return

        for hpa in hpas:

            namespace = hpa.metadata.namespace
            name = hpa.metadata.name

            current = hpa.status.current_replicas
            desired = hpa.status.desired_replicas

            print(f"✅ {namespace}/{name}")
            print(f"   Current Replicas : {current}")
            print(f"   Desired Replicas : {desired}\n")

    except Exception as e:

        print(f"Unable to retrieve HPA information: {e}")
        # ==========================================================
# Warning Events
# ==========================================================

def warning_events():

    print_section("Recent Warning Events")

    try:

        events = core_v1.list_event_for_all_namespaces().items

        warnings = 0

        for event in events:

            if event.type == "Warning":

                warnings += 1

                print(f"⚠ Namespace : {event.metadata.namespace}")
                print(f"  Object    : {event.involved_object.kind}/{event.involved_object.name}")
                print(f"  Reason    : {event.reason}")
                print(f"  Message   : {event.message}\n")

        if warnings == 0:
            print("✅ No Warning Events Found.")

    except Exception as e:

        print(f"Unable to fetch events: {e}")
        # ==========================================================
# Issues Summary
# ==========================================================

def issues_summary():

    print_section("Detected Issues")

    if len(issues) == 0:

        print("🎉 No Issues Found!")

        return

    for issue in issues:

        print(
            f"❌ {issue['resource']} | "
            f"{issue['namespace']} | "
            f"{issue['name']} | "
            f"{issue['reason']}"
        )

    print("-" * 70)
    print(f"Total Issues : {len(issues)}")
    # ==========================================================
# Recommendations
# ==========================================================

def recommendations():

    print_section("Recommendations")

    if len(issues) == 0:

        print("✅ Cluster is Healthy.")
        return

    for issue in issues:

        reason = issue["reason"]

        if "CrashLoopBackOff" in reason:

            print("• Check pod logs using:")
            print("  kubectl logs <pod-name> -n <namespace>\n")

        elif "ImagePullBackOff" in reason:

            print("• Verify image name and imagePullSecrets.\n")

        elif "OOMKilled" in reason:

            print("• Increase memory requests/limits.\n")

        elif "Node Not Ready" in reason:

            print("• Check kubelet status and node health.\n")

        elif "Available Replicas" in reason:

            print("• Investigate deployment rollout:")
            print("  kubectl describe deployment <deployment>\n")
            # ==========================================================
# Overall Health
# ==========================================================

def overall_health():

    print_title("OVERALL CLUSTER HEALTH")

    total = len(issues)

    if total == 0:

        print("🟢 HEALTHY")

    elif total <= 5:

        print("🟡 WARNING")

    else:

        print("🔴 CRITICAL")

    print(f"\nTotal Issues Detected : {total}")


# ==========================================================
# Main
# ==========================================================

def main():

    sys.stdout = DualOutput(REPORT_FILE)

    cluster_information()

    node_health()

    namespace_summary()

    pod_health()

    deployment_health()

    service_summary()

    persistent_volumes()

    persistent_volume_claims()

    statefulsets()

    daemonsets()

    hpa_health()

    warning_events()

    issues_summary()

    recommendations()

    overall_health()


if __name__ == "__main__":

    main()