//resource "helm_repository" "gitlab" {
//    name = "gitlab"
//    url  = "https://charts.gitlab.io"
//}
//
//resource "helm_chart" "gitlab-omnibus" {
//    name       = "gitlab-omnibus"
//    repository = "${helm_repository.gitlab.name}"
//    chart      = "gitlab-omnibus"
//}
