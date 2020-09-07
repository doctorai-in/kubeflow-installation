# Launching Kubernetes Dashboard
sudo minikube dashboard | exit
sudo kubectl proxy --address="0.0.0.0" --port=9090 --accept-hosts '.*'&