###for minikube 
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


######for eks and aws
# provider "aws" {
#     region = us-east-1
  
# }


# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.myvincluster.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.myvincluster.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1"
#       args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.myvincluster.id]
#       command     = "aws"
#     }
#   }
# }
