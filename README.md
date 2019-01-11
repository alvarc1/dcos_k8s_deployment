# dcos_k8s_deployment

Prerequisites:
  #dcos cluster setup http://34.217.30.38

Default K8s Cluster name: kubernetes-cluster1
Modify these files is a new name is required:
  Modify service-account.sh if a new service_account name is required
  Modify kubernetes-config-cris.json  for a new K8s config: Cluster name, service_account, secret

****   To run, in your working directory  ****
  #cp install-k8s-cris.sh install-k8s.sh
  #chmod +x *
  #./install-k8s.sh Master_IP K8s_Cluster
    Example: #./install-k8s.sh 34.217.30.38 kubernetes-cluster1


****   To Finish  ****
  dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --context-name=$SERVICE_ACCOUNT \
    --cluster-name=$SERVICE_ACCOUNT \
    --apiserver-url=$PUBLICURL:6443

  kubectl get nodes
  kubectl proxy

  To login the K8s UI:
    http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
    Kubeconfig -> Select your config file: current_dir: Users/cristina/.kube/config


TIPS:
  To get the content of a secret: #dcos security secrets get kubernetes-cluster1/sa
  To cleanup the context
    #kubectl config view
    To delete a context: #kubectl config delete-context kubernetes-cluster1
    To delete a cluster: #kubectl config delete-cluster kubernetes-cluster1
    To delete an user: #kubectl config unset users.kubernetes-cluster2
    To check the current context: #kubectl config current-context


  dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --context-name=kubernetes-cluster1 \
    --cluster-name=kubernetes-cluster1 \
    --apiserver-url=https://54.212.46.227:6443
