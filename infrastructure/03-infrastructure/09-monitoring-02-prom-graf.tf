resource "helm_release" "kube-prometheus" {
  count               = var.kubernetes-enabled && var.monitoring-enabled ? 1 : 0
  depends_on          = [
    azurerm_kubernetes_cluster.codehunters-aks-cluster[0] #,
    # helm_release.loki
  ]

  name                = "kube-prometheus"
  namespace           = "monitoring"
  repository          = "https://prometheus-community.github.io/helm-charts"
  chart               = "kube-prometheus-stack"
  create_namespace    = true
  values = [file("${path.module}/09-monitoring-03-prom-graf-settings.yaml")]
}