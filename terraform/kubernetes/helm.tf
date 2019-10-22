resource "helm_repository" "celmatix" {
  name = "celmatix"
  url = "http://minio-minio-svc:9000/helm-repo"
}

//resource "helm_chart" "keel" {
//  name = "keel"
//  chart = "keel"
//  repository = "stable"
//
//  set {
//    name = "helmProvider.enabled"
//    value = "true"
//  }
//
//  # TODO - expose this via ingress or internal service instead of loadbalancer
//  set {
//    name = "service.enable"
//    value = "true"
//  }
//}
