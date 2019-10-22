variable "kafka_zookeeper_persistence_log_size" {
  type    = "string"
  default = "512Mi"
}

variable "kafka_zookeeper_persistence_data_size" {
  type    = "string"
  default = "512Mi"
}

variable "kafka_zookeeper_resources_limits_cpu" {
  type    = "string"
  default = "1000m"
}

variable "kafka_zookeeper_resources_limits_memory" {
  type    = "string"
  default = "1024Mi"
}

variable "kafka_zookeeper_resources_requests_cpu" {
  type    = "string"
  default = "100m"
}

variable "kafka_zookeeper_resources_requests_memory" {
  type    = "string"
  default = "512Mi"
}

variable "kafka_zookeeper_max_client_connections" {
  type    = "string"
  default = "60"
}

resource "helm_chart" "kafka_zookeeper" {
  name = "kafka-zookeeper"
  chart = "zookeeper"
  repository = "${helm_repository.celmatix.metadata.0.name}"

  set {
    name = "persistence.log.size"
    value = "${var.kafka_zookeeper_persistence_log_size}"
  }

  set {
    name = "persistence.data.size"
    value = "${var.kafka_zookeeper_persistence_data_size}"
  }

  set {
    name = "resources.limits.cpu"
    value = "${var.kafka_zookeeper_resources_limits_cpu}"
  }

  set {
    name = "resources.limits.memory"
    value = "${var.kafka_zookeeper_resources_limits_memory}"
  }

  set {
    name = "resources.requests.cpu"
    value = "${var.kafka_zookeeper_resources_requests_cpu}"
  }

  set {
    name = "resources.requests.memory"
    value = "${var.kafka_zookeeper_resources_requests_memory}"
  }

  set {
    name = "zookeeper.maxClientCnxns"
    value = "${var.kafka_zookeeper_max_client_connections}"
  }
}
