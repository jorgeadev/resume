variable "schema_registry_resources_limits_cpu" {
  type    = "string"
  default = "1000m"
}

variable "schema_registry_resources_limits_memory" {
  type    = "string"
  default = "1024Mi"
}

variable "schema_registry_resources_requests_cpu" {
  type    = "string"
  default = "100m"
}

variable "schema_registry_resources_requests_memory" {
  type    = "string"
  default = "512Mi"
}

# TODO - finish adding dependencies / internal / external flags
resource "helm_chart" "schema_registry" {
  name = "schema-registry"
  chart = "schema-registry"
  repository = "${helm_repository.celmatix.metadata.0.name}"

  set {
    name = "image.pullPolicy"
    value = "Always"
  }

  # TODO - convert this to use externalZookeeper and requirements.yaml
  set {
    name = "schemaregistry.zookeeperConnect"
    value = "${helm_chart.kafka_zookeeper.name}-${helm_chart.kafka_zookeeper.chart}:2181"
  }

  set {
    name = "schemaregistry.kafkaStore.bootstrapServers"
    value = "SSL://${helm_chart.kafka.name}-${helm_chart.kafka.chart}:9092"
  }

  set {
    name = "ingress.enabled"
    value = "true"
  }

  set {
    name = "ingress.hosts"
    value = "{schema-registry.celmatix.net}"
  }

  set {
    name = "resources.limits.cpu"
    value = "${var.schema_registry_resources_limits_cpu}"
  }

  set {
    name = "resources.limits.memory"
    value = "${var.schema_registry_resources_limits_memory}"
  }

  set {
    name = "resources.requests.cpu"
    value = "${var.schema_registry_resources_requests_cpu}"
  }

  set {
    name = "resources.requests.memory"
    value = "${var.schema_registry_resources_requests_memory}"
  }
}
