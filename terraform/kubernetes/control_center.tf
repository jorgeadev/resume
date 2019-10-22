//variable "control_center_resources_limits_cpu" {
//  type    = "string"
//  default = "1000m"
//}
//
//variable "control_center_resources_limits_memory" {
//  type    = "string"
//  default = "1024Mi"
//}
//
//variable "control_center_resources_requests_cpu" {
//  type    = "string"
//  default = "100m"
//}
//
//variable "control_center_resources_requests_memory" {
//  type    = "string"
//  default = "512Mi"
//}
//
//# TODO - finish adding dependencies / internal / external flags
//resource "helm_chart" "control_center" {
//  name = "kafka-connect"
//  chart = "kafka-connect"
//  repository = "${helm_repository.celmatix.metadata.0.name}"
//
//  set {
//    name = "image.repository"
//    value = "localhost:5000/celmatix/kafka-connect"
//  }
//
//  set {
//    name = "image.pullPolicy"
//    value = "Always"
//  }
//
//  # TODO - convert this to use externalZookeeper and requirements.yaml
//  set {
//    name = "connect.zookeeperConnect"
//    value = "${helm_chart.kafka_zookeeper.name}-${helm_chart.kafka_zookeeper.chart}:2181"
//  }
//
//  set {
//    name = "connect.bootstrapServers"
//    value = "SSL://${helm_chart.kafka.name}-${helm_chart.kafka.chart}:9092"
//  }
//
//  set {
//    name = "connect.keyConverterSchemaRegistryUrl"
//    value = "https://${helm_chart.schema_registry.name}-${helm_chart.schema_registry.chart}:8081"
//  }
//
//  set {
//    name = "connect.valueConverterSchemaRegistryUrl"
//    value = "https://${helm_chart.schema_registry.name}-${helm_chart.schema_registry.chart}:8081"
//  }
//
//  set {
//    name = "ingress.enabled"
//    value = "true"
//  }
//
//  set {
//    name = "ingress.hosts"
//    value = "{controlcenter.celmatix.net}"
//  }
//
//  set {
//    name = "resources.limits.cpu"
//    value = "${var.control_center_resources_limits_cpu}"
//  }
//
//  set {
//    name = "resources.limits.memory"
//    value = "${var.control_center_resources_limits_memory}"
//  }
//
//  set {
//    name = "resources.requests.cpu"
//    value = "${var.control_center_resources_requests_cpu}"
//  }
//
//  set {
//    name = "resources.requests.memory"
//    value = "${var.control_center_resources_requests_memory}"
//  }
//}
