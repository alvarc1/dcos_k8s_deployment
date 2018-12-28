Prerequisites:
  #dcos cluster setup http://34.221.225.74

Default K8s Cluster name: kubernetes-cluster1
Modify these files is a new name is required:
  Modify service-account.sh if a new service_account name is required
  Modify kubernetes-config-cris.json  for a new K8s config: Cluster name, service_account, secret

To run, in your working directory
  #cp install-k8s-cris.sh install-k8s.sh
  #chmod +x *
  #./install-k8s.sh 34.221.225.74 kubernetes-cluster1
  ./install-k8s.sh 34.221.225.74 kubernetes-cluster1

TIPS:
  To delete a context: #kubectl config delete-context kubernetes-cluster1
  To get the content of a secret: #dcos security secrets get kubernetes-cluster1/sa
