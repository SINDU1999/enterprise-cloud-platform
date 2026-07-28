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
import json
from kubernetes.client import CustomObjectsApi
from automation.aws.s3_upload import upload_to_s3
from automation.aws.sns_notification import send_notification
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
# ==========================================================
# Report Data
# ==========================================================

report_data = {}
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

REPORT_DIR = os.path.join(BASE_DIR, "reports")

os.makedirs(REPORT_DIR, exist_ok=True)

REPORT_FILE = os.path.join(
    REPORT_DIR,
    f"cluster_health_{REPORT_TIME.strftime('%Y%m%d_%H%M%S')}.txt"
)

JSON_REPORT_FILE = os.path.join(
    REPORT_DIR,
    f"cluster_health_{REPORT_TIME.strftime('%Y%m%d_%H%M%S')}.json"
)
# ==========================================================
# AWS S3 Configuration
# ==========================================================

S3_BUCKET_NAME = "enterprise-cloud-health-reports-908209635299"
# ==========================================================
# AWS SNS Configuration
# ==========================================================

SNS_TOPIC_ARN = "arn:aws:sns:ap-south-1:908209635299:enterprise-cluster-health-alerts"
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

    def close(self):
        self.log.close()


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

        report_data["cluster_information"] = {
    "generated_at": REPORT_TIME.strftime("%Y-%m-%d %H:%M:%S"),
    "current_context": context_name,
    "cluster_name": cluster_name,
    "kubernetes_version": version.git_version
}

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

    report_data["node_health"] = {
    "total_nodes": len(nodes),
    "ready_nodes": ready_nodes,
    "not_ready_nodes": not_ready_nodes
}

    return ready_nodes, not_ready_nodes

# ==========================================================
# Metric Conversion Helpers
# ==========================================================

def format_cpu(cpu_value):
    """
    Convert Kubernetes CPU values to millicores (m).
    """

    if cpu_value.endswith("n"):
        milli = int(cpu_value[:-1]) / 1_000_000

        if milli < 1:
            return f"{milli:.2f}m"

        return f"{milli:.0f}m"

    return cpu_value


def format_memory(memory_value):
    """
    Convert Kubernetes memory values to Mi.
    Example:
        1474672Ki -> 1440Mi
    """
    if memory_value.endswith("Ki"):
        return f"{int(memory_value[:-2]) // 1024}Mi"

    return memory_value


def node_resource_utilization():

    print_title("NODE RESOURCE UTILIZATION")

    custom_api = CustomObjectsApi()

    metrics = custom_api.list_cluster_custom_object(
        group="metrics.k8s.io",
        version="v1beta1",
        plural="nodes"
    )

    print(f"{'Node':<45} {'CPU':<10} {'Memory':<15}")
    print("-" * 75)

    node_metrics = []

    for item in metrics["items"]:

        node_name = item["metadata"]["name"]

        cpu_raw = item["usage"]["cpu"]
        memory_raw = item["usage"]["memory"]

        cpu = format_cpu(cpu_raw)
        memory = format_memory(memory_raw)

        print(f"{node_name:<45} {cpu:<10} {memory:<15}")

        node_metrics.append({
            "node": node_name,
            "cpu": {
                "raw": cpu_raw,
                "formatted": cpu
           },
           "memory": {
               "raw": memory_raw,
               "formatted": memory
           }
    })
            
        

    report_data["node_resource_utilization"] = node_metrics

def pod_resource_utilization():

    print_title("POD RESOURCE UTILIZATION")

    custom_api = CustomObjectsApi()

    metrics = custom_api.list_cluster_custom_object(
        group="metrics.k8s.io",
        version="v1beta1",
        plural="pods"
    )

    print(f"{'Namespace':<20} {'Pod':<45} {'CPU':<10} {'Memory':<10}")
    print("-" * 90)

    pod_metrics = []

    for item in metrics["items"]:

        namespace = item["metadata"]["namespace"]
        pod_name = item["metadata"]["name"]

        total_cpu = 0
        total_memory = 0

        for container in item["containers"]:

            cpu_raw = container["usage"]["cpu"]
            memory_raw = container["usage"]["memory"]

            # Convert CPU
            if cpu_raw.endswith("n"):
                total_cpu += int(cpu_raw[:-1])

            # Convert Memory
            if memory_raw.endswith("Ki"):
                total_memory += int(memory_raw[:-2])

        cpu_formatted = format_cpu(f"{total_cpu}n")
        memory_formatted = format_memory(f"{total_memory}Ki")

        print(
            f"{namespace:<20} "
            f"{pod_name:<45} "
            f"{cpu_formatted:<10} "
            f"{memory_formatted:<10}"
        )

        pod_metrics.append({
            "namespace": namespace,
            "pod": pod_name,
            "cpu": {
                "raw": f"{total_cpu}n",
                "formatted": cpu_formatted
            },
            "memory": {
                "raw": f"{total_memory}Ki",
                "formatted": memory_formatted
            }
        })

    report_data["pod_resource_utilization"] = pod_metrics

def namespace_resource_usage():

    print_title("NAMESPACE RESOURCE USAGE")

    print(f"{'Namespace':<20} {'CPU Usage':<15} {'Memory Usage':<15}")
    print("-" * 55)

    namespace_usage = {}

    # Reuse pod metrics already collected
    for pod in report_data["pod_resource_utilization"]:

        namespace = pod["namespace"]

        cpu = float(pod["cpu"]["formatted"].replace("m", ""))
        memory = float(pod["memory"]["formatted"].replace("Mi", ""))

        if namespace not in namespace_usage:
            namespace_usage[namespace] = {
                "cpu": 0.0,
                "memory": 0.0
            }

        namespace_usage[namespace]["cpu"] += cpu
        namespace_usage[namespace]["memory"] += memory 

        namespace_report = []

    for namespace, usage in namespace_usage.items():

        cpu = round(usage["cpu"], 2)
        memory = round(usage["memory"], 2)

        print(
            f"{namespace:<20}"
            f"{cpu:.2f}m"
            f"{'':<6}"
            f"{memory:.2f}Mi"
      )

        namespace_report.append({
            "namespace": namespace,
            "cpu": f"{cpu}m",
            "memory": f"{memory}Mi"
        })

    report_data["namespace_resource_usage"] = namespace_report 

def top_cpu_consumers():

    print_title("TOP CPU CONSUMERS")

    print(f"{'Rank':<6} {'Namespace':<18} {'Pod':<45} {'CPU':<10}")
    print("-" * 85)

    cpu_list = []

    for pod in report_data["pod_resource_utilization"]:

        cpu = float(pod["cpu"]["formatted"].replace("m", ""))

        cpu_list.append({
            "namespace": pod["namespace"],
            "pod": pod["pod"],
            "cpu": cpu
        })

    cpu_list = sorted(
        cpu_list,
        key=lambda x: x["cpu"],
        reverse=True
    )
    top_cpu_report = []

    for rank, pod in enumerate(cpu_list[:5], start=1):

        print(
            f"{rank:<6}"
            f"{pod['namespace']:<18}"
            f"{pod['pod']:<55}"
            f"{pod['cpu']:>8.2f}m"
       )

        top_cpu_report.append({
            "rank": rank,
            "namespace": pod["namespace"],
            "pod": pod["pod"],
            "cpu": f"{pod['cpu']:.2f}m"
        })

    report_data["top_cpu_consumers"] = top_cpu_report 

def top_memory_consumers():

    print_title("TOP MEMORY CONSUMERS")

    print(f"{'Rank':<6} {'Namespace':<18} {'Pod':<55} {'Memory':<10}")
    print("-" * 95)

    memory_list = []

    for pod in report_data["pod_resource_utilization"]:

        memory = float(
            pod["memory"]["formatted"].replace("Mi", "")
        )

        memory_list.append({
            "namespace": pod["namespace"],
            "pod": pod["pod"],
            "memory": memory
        })

    memory_list = sorted(
        memory_list,
        key=lambda x: x["memory"],
        reverse=True
    ) 
    top_memory_report = []

    for rank, pod in enumerate(memory_list[:5], start=1):

        print(
            f"{rank:<6}"
            f"{pod['namespace']:<18}"
            f"{pod['pod']:<55}"
            f"{pod['memory']:>8.2f}Mi"
        )

        top_memory_report.append({
            "rank": rank,
            "namespace": pod["namespace"],
            "pod": pod["pod"],
            "memory": f"{pod['memory']:.2f}Mi"
        })

    report_data["top_memory_consumers"] = top_memory_report       

   
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

    report_data["pod_health"] = {
    "total_pods": len(pods),
    "running": running,
    "pending": pending,
    "failed": failed,
    "succeeded": succeeded,
    "unknown": unknown,
    "crashloopbackoff": crashloop,
    "imagepullbackoff": imagepull,
    "errimagepull": errimagepull,
    "oomkilled": oomkilled,
    "evicted": evicted
}

    return {
        "running": running,
        "pending": pending,
        "failed": failed,
        "crashloop": crashloop,
        "imagepull": imagepull,
        "oomkilled": oomkilled,
        "evicted": evicted,
    }
def container_restart_analysis():

    print_title("CONTAINER RESTART ANALYSIS")

    v1 = client.CoreV1Api()

    pods = v1.list_pod_for_all_namespaces().items

    restarting_pods = []
    total_restarting = 0

    for pod in pods:

        if not pod.status.container_statuses:
            continue

        for container in pod.status.container_statuses:

            if container.restart_count > 0:

                restarting_pods.append({
                    "namespace": pod.metadata.namespace,
                    "pod": pod.metadata.name,
                    "container": container.name,
                    "restarts": container.restart_count
                })

                total_restarting += 1

    if restarting_pods:

        print(f"{'Namespace':<20} {'Pod':<45} {'Container':<25} {'Restarts':>10}")
        print("-" * 105)

        for item in restarting_pods:

            print(
                f"{item['namespace']:<20} "
                f"{item['pod']:<45} "
                f"{item['container']:<25} "
                f"{item['restarts']:>10}"
            )

    else:

        print("✅ No container restarts detected.")

    print("-" * 105)
    print(f"Total Restarting Containers : {total_restarting}")

    report_data["container_restart_analysis"] = {
        "total_restarting_containers": total_restarting,
        "details": restarting_pods
    }
    if total_restarting > 0:
        issues.append({
    "resource": "...",
    "namespace": "...",
    "name": "...",
    "reason": "..."
})
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

    report_data["deployment_health"] = {
    "total_deployments": len(deployments),
    "healthy_deployments": len(deployments) - unhealthy,
    "unhealthy_deployments": unhealthy
}

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

    END_TIME = time.time()
    EXECUTION_TIME = round(END_TIME - START_TIME, 2)

    print(f"\nExecution Time       : {EXECUTION_TIME} seconds")

    report_data["execution_summary"] = {
        "execution_time_seconds": EXECUTION_TIME,
        "total_issues": total,
        "overall_health": (
            "HEALTHY" if total == 0
            else "WARNING" if total <= 5
            else "CRITICAL"
        )
    }
# ==========================================================
# Save JSON Report
# ==========================================================

def save_json_report():

    with open(JSON_REPORT_FILE, "w", encoding="utf-8") as json_file:

        json.dump(report_data, json_file, indent=4)

    print(f"\n✅ JSON report saved to: {JSON_REPORT_FILE}")

    upload_to_s3(
        file_path=JSON_REPORT_FILE,
        bucket_name=S3_BUCKET_NAME,
        s3_key=f"reports/{os.path.basename(JSON_REPORT_FILE)}"
    )    



# ==========================================================
# Main
# ==========================================================

def main():

    sys.stdout = DualOutput(REPORT_FILE)

    cluster_information()
    node_health()
    node_resource_utilization()
    pod_resource_utilization()
    namespace_resource_usage()
    top_cpu_consumers()
    top_memory_consumers()
    namespace_summary()
    pod_health()
    container_restart_analysis()
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

    # Flush everything written to the TXT report
    sys.stdout.flush()

    original_stdout = sys.stdout.terminal
    sys.stdout.close()
    sys.stdout = original_stdout

    # Upload TXT Report
    upload_to_s3(
        file_path=REPORT_FILE,
        bucket_name=S3_BUCKET_NAME,
        s3_key=f"reports/{os.path.basename(REPORT_FILE)}"
    )

    # Upload JSON Report
    save_json_report()

    # SNS Notification
    subject = "Enterprise Kubernetes Health Report"

    message = f"""
Enterprise Kubernetes Health Report

Cluster Health Check Completed Successfully

Overall Health:
{report_data["execution_summary"]["overall_health"]}

Total Issues:
{report_data["execution_summary"]["total_issues"]}

Execution Time:
{report_data["execution_summary"]["execution_time_seconds"]} seconds

Generated At:
{REPORT_TIME.strftime("%Y-%m-%d %H:%M:%S")}

S3 Bucket:
{S3_BUCKET_NAME}

Reports Uploaded:

TXT:
{os.path.basename(REPORT_FILE)}

JSON:
{os.path.basename(JSON_REPORT_FILE)}
"""

    send_notification(
        topic_arn=SNS_TOPIC_ARN,
        subject=subject,
        message=message
    )


if __name__ == "__main__":
    main()