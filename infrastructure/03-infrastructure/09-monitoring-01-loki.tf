# resource "helm_release" "loki" {
#   count               = var.kubernetes-enabled && var.monitoring-enabled ? 1 : 0
#
#   depends_on          = [
#     azurerm_kubernetes_cluster.codehunters-aks-cluster[0],
#   ]
#
#   name       = "loki"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "loki"
#   version    = "5.10.0"
#   namespace  = "monitoring"
#
#   values = [file("${path.module}/09-monitoring-04-loki-settings.yaml")]
# }