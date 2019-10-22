resource "kubernetes_namespace" "openfaas" {
  provider = "kubernetes.local"

  metadata {
    name = "openfaas"
  }
}

resource "kubernetes_namespace" "openfaas_fn" {
  provider = "kubernetes.local"

  metadata {
    name = "openfaas-fn"
  }
}

resource "helm_chart" "openfaas" {
  name = "openfaas"
  chart = "openfaas"
  repository = "${helm_repository.celmatix.metadata.0.name}"

  namespace = "${kubernetes_namespace.openfaas.metadata.0.name}"

  set {
    name = "functionNamespace"
    value = "${kubernetes_namespace.openfaas_fn.metadata.0.name}"
  }

  # HEREDOC syntax required as the hostnames needed to be set within the list,
  # which is not supported in the provider
  values = <<EOF
async: true
exposeServices: false
rbac: false

image:
  pullPolicy: Always

ingress:
  enabled: true
  # Used to create Ingress record (should be used with exposeServices: false).
  hosts:
    - host: faas-netesd.openfaas.celmatix.net
      serviceName: faas-netesd
      servicePort: 8080
      path: /
    - host: gateway.openfaas.celmatix.net
      serviceName: gateway
      servicePort: 8080
      path: /
    - host: prometheus.openfaas.celmatix.net
      serviceName: prometheus
      servicePort: 9090
      path: /
    - host: alertmanager.openfaas.celmatix.net
      serviceName: alertmanager
      servicePort: 9093
      path: /
EOF
}
