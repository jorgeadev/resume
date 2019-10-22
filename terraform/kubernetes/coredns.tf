//resource "helm_chart" "coredns" {
//  name = "coredns"
//  chart = "coredns"
//  repository = "${helm_repository.celmatix.metadata.0.name}"
//
//  namespace = "kube-system"
//
//  set {
//    name = "middleware.debug.enabled"
//    value = "true"
//  }
//
//  set {
//    name = "middleware.rewrite.enabled"
//    value = "true"
//  }
//
//  set {
//    name = "middleware.rewrite.rules"
//    value = <<EOF
//[{
//  field: "name"
//  continue: "no"
//  from: "minio.celmatix.net"
//  to: "minio-minio-svc.default.cluster.local"
//}, {
//  field: "name"
//  continue: "no"
//  from: "drill.celmatix.net"
//  to: "drill-drill.default.svc.cluster.local"
//}]
//EOF
//  }
//
////  values = <<EOF
////middleware:
////  rewrite:
////    enabled: true
////    rules:
////    - field: name
////      continue: no
////      from: minio.celmatix.net
////      to: minio-minio-svc.default.svc.cluster.local
////    - field: name
////      continue: no
////      from: drill.celmatix.net
////      to: drill-drill.default.svc.cluster.local
////EOF
//}
