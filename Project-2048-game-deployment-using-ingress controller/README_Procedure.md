eksctl create cluster --name vin-cluster --region us-east-1 --fargate

 
 aws eks update-kubeconfig --region us-east-1 --name vin-cluster
 
 
eksctl create fargateprofile \
    --cluster vin-cluster \
    --region us-east-1 \
    --name Alb-vin-fargate-name \
    --namespace vnamespace








create a file  kubectl apply -f dep-svc-ns-ingress.yaml

---
apiVersion: v1
kind: Namespace
metadata:
  name: vnamespace
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: vnamespace
  name: deployment-2048
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: app-2048vin
  replicas: 5
  template:
    metadata:
      labels:
        app.kubernetes.io/name: app-2048vin
    spec:
      containers:
      - image: public.ecr.aws/l6m2t8p7/docker-2048:latest
        imagePullPolicy: Always
        name: app-2048
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  namespace: vnamespace
  name: service-2048
spec:
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
  type: NodePort
  selector:
    app.kubernetes.io/name: app-2048vin
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: vnamespace
  name: ingress-2048
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: service-2048
              port:
                number: 80
                
          


   
   
      
                
  kubectl edit  ingress -n vnamespace

eksctl utils associate-iam-oidc-provider --cluster vin-cluster  --approve                   ###### we need this OIDC connect provider b'caz ALB controller need access to aws LB services to communicate. the pods  need to commincate some aws resources.these allow to create ingress controller of ALB



curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json    ####to give permission to pods from accessing aws services such as ALB ec2 
vim  iam_policy.json
copy all the 


aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
    
    
    
    
    
    
eksctl create iamserviceaccount \
  --cluster=vin-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::339712801272:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
    
    
    
 helm repo add eks https://aws.github.io/eks-charts
 
 helm repo update eks
 
 
 
 ####install ALB controller via helm
 helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
  --set clusterName=vin-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-0305157c51cf258ed


