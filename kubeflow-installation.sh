# First Time Installation.
echo "First Time Installation "
# Install Docker Community Edition.
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    Stable"
apt-get update
apt-get install -y docker-ce

# Install kubectl 
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
sudo chmod -R 777 ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install Minikube
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.0.0/minikube-linux-amd64
 # move to /usr/local/bin directory
sudo chmod +x minikube
sudo cp minikube /usr/local/bin/
rm minikube

# Start Minikube.
echo ".....Deleting Existing kubernetes Cluster....."
sudo minikube delete
echo ".....Starting kubernetes clusters....."
sudo minikube start --vm-driver=none --cpus 6 --memory 12288 --disk-size=120g --extra-config=apiserver.authorization-mode=RBAC --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf --extra-config kubeadm.ignore-preflight-errors=SystemVerification
sudo mv /home/omen/.kube /home/omen/.minikube $HOME
sudo chown -R $USER $HOME/.kube $HOME/.minikube
sudo kubectl create ns kubeflow-anonymous
# Installing Kubeflow
echo ".....Deploying Kubeflow on Kubernetes Clusters....."

export kubeflow=/home/kubeflow
# Deleting If /home/kubeflow Exist
if [ -d "${kubeflow}" ]; then
  ### Take action if $DIR exists ###
  sudo rm -r ${kubeflow}
  echo "Deleting ${kubeflow} directory..."
fi

sudo mkdir ${kubeflow}
sudo chmod -R 777 ${kubeflow}
sudo cp kfctl_k8s_istio.0.6.2.yaml ${kubeflow}
sudo cp create_cluster.sh ${kubeflow}
sudo cp deploy_kubeflow.sh ${kubeflow}
sudo cp Launch_Kubernetes_Dsaboard.sh ${kubeflow}
sudo cp commands.txt ${kubeflow}

# Change Directory
cd ${kubeflow}
echo ".....we are in ${kubflow}....."
# Download Necessary packages manifest and kubeflow tar and kfctl
wget https://github.com/kubeflow/manifests/archive/56e2fb15db286198f7a53723cb1fbfecf3fe83fb.tar.gz
wget https://github.com/kubeflow/kubeflow/archive/0dbd2550372c003ba69069aeee283bd59fb1341f.tar.gz
wget https://github.com/kubeflow/kubeflow/releases/download/v0.6.2/kfctl_v0.6.2_linux.tar.gz

# Untar files
tar -xvf 56e2fb15db286198f7a53723cb1fbfecf3fe83fb.tar.gz
tar -xvf 0dbd2550372c003ba69069aeee283bd59fb1341f.tar.gz
tar -xvf kfctl_v0.6.2_linux.tar.gz

# Removing downloaded tar file after extraction
sudo rm -r 56e2fb15db286198f7a53723cb1fbfecf3fe83fb.tar.gz
sudo rm -r 0dbd2550372c003ba69069aeee283bd59fb1341f.tar.gz
sudo rm -r kfctl_v0.6.2_linux.tar.gz

cd ${kubeflow}
export PATH=$PATH:${kubeflow}
export KFAPP=kfapp
export CONFIG=${kubeflow}/kfctl_k8s_istio.0.6.2.yaml

kfctl init ${KFAPP} --config=${CONFIG} -V

cd ${KFAPP}
kfctl generate all -V        
kfctl apply all -V
