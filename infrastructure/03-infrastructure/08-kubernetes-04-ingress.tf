resource "helm_release" "ingress" {
  count      = var.kubernetes-enabled ? 1 : 0
  depends_on = [azurerm_kubernetes_cluster.codehunters-aks-cluster[0]]

  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

}