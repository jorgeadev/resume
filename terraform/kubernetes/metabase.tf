//variable "metabase_postgres_root_user" {
//  default = "postgres"
//}
//variable "metabase_postgres_root_pass" {
//  default = "foobar"
//}
//variable "metabase_postgres_user" {
//  default = "metabase"
//}
//variable "metabase_postgres_pass" {
//  default = "foobar"
//}
//
//# TODO - backup strategy
//resource "helm_chart" "metabase_postgres" {
//  name = "metabase-postgres"
//  chart = "postgresql"
//  repository = "stable"
//
//  set {
//    name = "image"
//    value = "postgres"
//  }
//
//  set {
//    name = "imageTag"
//    value = "9.6.5-alpine"
//  }
//
//  set {
//    name = "imagePullPolicy"
//    value = "Always"
//  }
//
//  set {
//    name = "postgresUser"
//    value = "${var.metabase_postgres_root_user}"
//  }
//
//  set {
//    name = "postgresPassword"
//    value = "${var.metabase_postgres_root_pass}"
//  }
//}
//
//provider "postgresql" {
//  alias = "metabase"
//  host = "${helm_chart.metabase_postgres.name}-${helm_chart.metabase_postgres.chart}"
//  port = 5432
//  database = "postgres"
//  # TODO - determine how to link these with the helm chart
//  # Maybe follow https://github.com/hashicorp/terraform/issues/516#issuecomment-276119309
//  username = "${var.metabase_postgres_root_user}"
//  password = "${var.metabase_postgres_root_pass}"
//  connect_timeout = 60
//  sslmode = "disable"
//}
//
//resource "postgresql_role" "metabase_user" {
//  provider = "postgresql.metabase"
//
//  name = "${var.metabase_postgres_user}"
//  login = true
//  password = "${var.metabase_postgres_pass}"
//
//  depends_on = ["helm_chart.metabase_postgres"]
//}
//
//resource "postgresql_database" "metabase_db" {
//  provider = "postgresql.metabase"
//
//  name = "metabase_db"
//  # TODO - create metabase specific user
//  owner = "${postgresql_role.metabase_user.name}"
//
//  depends_on = ["postgresql_role.metabase_user"]
//}
//
//resource "helm_chart" "metabase" {
//  name = "metabase"
//  chart = "metabase"
//  repository = "stable"
//
//  set {
//    name = "image.repository"
//    value = "localhost:5000/celmatix/metabase"
//  }
//
//  set {
//    name = "image.tag"
//    value = "v0.24.2-celmatix"
//  }
//
//  set {
//    name = "database.type"
//    value = "postgres"
//  }
//
//  set {
//    name = "database.host"
//    value = "${helm_chart.metabase_postgres.name}-${helm_chart.metabase_postgres.chart}"
//  }
//
//  set {
//    name = "database.port"
//    value = "5432"
//  }
//
//  set {
//    name = "database.dbname"
//    value = "${postgresql_database.metabase_db.name}"
//  }
//
//  set {
//    name = "database.username"
//    value = "${postgresql_role.metabase_user.name}"
//  }
//
//  # TODO - sync this with the role in metabase_db
//  set {
//    name = "database.password"
//    value = "${postgresql_role.metabase_user.password}"
//  }
//
//  set {
//    name = "ingress.enabled"
//    value = "true"
//  }
//
//  set {
//    name = "ingress.hosts"
//    value = "{metabase.celmatix.net}"
//  }
//}
