variable "kafka_persistence_log_size" {
  type    = "string"
  default = "512Mi"
}

variable "kafka_persistence_data_size" {
  type    = "string"
  default = "512Mi"
}

variable "kafka_resources_limits_cpu" {
  type    = "string"
  default = "1000m"
}

variable "kafka_resources_limits_memory" {
  type    = "string"
  default = "1024Mi"
}

variable "kafka_resources_requests_cpu" {
  type    = "string"
  default = "100m"
}

variable "kafka_resources_requests_memory" {
  type    = "string"
  default = "512Mi"
}

resource "helm_chart" "kafka" {
  name = "kafka"
  chart = "kafka"
  repository = "${helm_repository.celmatix.metadata.0.name}"

  set {
    name = "persistence.log.size"
    value = "${var.kafka_persistence_log_size}"
  }

  set {
    name = "persistence.data.size"
    value = "${var.kafka_persistence_data_size}"
  }

  set {
    name = "resources.limits.cpu"
    value = "${var.kafka_resources_limits_cpu}"
  }

  set {
    name = "resources.limits.memory"
    value = "${var.kafka_resources_limits_memory}"
  }

  set {
    name = "resources.requests.cpu"
    value = "${var.kafka_resources_requests_cpu}"
  }

  set {
    name = "resources.requests.memory"
    value = "${var.kafka_resources_requests_memory}"
  }

  set {
    name = "image.pullPolicy"
    value = "Always"
  }

  set {
    name = "zookeeper.enabled"
    value = "false"
  }

  set {
    name = "externalZookeeper.connect"
    value = "${helm_chart.kafka_zookeeper.name}-${helm_chart.kafka_zookeeper.chart}:2181"
  }

  # TODO - why do we do this?
  set {
    name = "kafka.createTopics"
    value = "test-topic:2:1"
  }
}
