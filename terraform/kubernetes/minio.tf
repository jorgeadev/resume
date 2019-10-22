resource "helm_chart" "minio" {
  name = "minio"
  chart = "minio"
  repository = "stable"

  set {
    name = "serviceType"
    value = "ClusterIP"
  }
}
