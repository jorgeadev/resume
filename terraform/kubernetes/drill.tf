//resource "helm_chart" "drill" {
//  name = "drill"
//  chart = "apache-drill"
//  repository = "${helm_repository.celmatix.metadata.0.name}"
//
//  set {
//    name = "image.pullPolicy"
//    value = "Always"
//  }
//
//  set {
//    name = "ingress.enabled"
//    value = "true"
//  }
//
//  set {
//    name = "ingress.hosts"
//    value = "{drill.celmatix.net}"
//  }
//}
