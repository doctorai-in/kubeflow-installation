# Installation Steps
# Command 1: Complete Installation
Command 1: command is used for first time installation it will install docker, kubectl, minikube and deploying Kubeflow on kubernetes clusters.
- sudo ./kubeflow-installation.sh
# After installation run following commands:
- sudo kubectl get pod -n kubeflow 
# if all pods are running otherwise wait 
- export INGRESS_HOST=$(minikube ip)
- export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
# To Create Url to access Kubeflow Dashboard
- http://$INGRESS_HOST:$INGRESS_PORT

# Command 2
Command 2. Only for delete existing cluster and create new clusters and deploy kubeflow.
- sudo ./create_cluster.sh 
- sudo ./deploy_kubeflow.sh   

# Command 3
Command 3: Launch Kubernetes Dashboard
- sudo ./Launch_Kubernetes_Dsaboard.sh

Commands.txt file contain serveral commands that we used.
