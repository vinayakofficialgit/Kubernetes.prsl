####if you to install via manifest then below  line
# helm install argocd -n argocd --create-namespace argo/argo-cd --version 3.35.4 -f terraform/values/argocd.yaml




##################################################################################################################################

##or install argocd through helm 
resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"

  values = [file("values/argocd-values.yaml")]     ##to override any variable  two way set statement or value 
}
