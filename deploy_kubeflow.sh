# Installing Kubeflow
export kubeflow=/home/kubeflow
cd ${kubeflow}
export PATH=$PATH:${kubeflow}
export KFAPP=kfapp
export CONFIG=${kubeflow}/kfctl_k8s_istio.0.6.2.yaml

if [ -d "${KFAPP}" ]; then
  ### Take action if $DIR exists ###
  sudo rm -r ${KFAPP}
  echo "Deleting ${KFAPP}..."
fi

kfctl init ${KFAPP} --config=${CONFIG} -V

cd ${KFAPP}
kfctl generate all -V        
kfctl apply all -V
