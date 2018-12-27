//Pre: dcos cluster setup http://34.219.94.136


cp install-k8s-cris.TEMPLATE install-k8s.sh
chmod +x install-k8s.sh


//Modify service-account.sh if a new service_account name is required
//Modify kubernetes-config-cris.json  for a new K8s config

./install-k8s.sh 34.219.94.136 kubernetes-cluster1

//./check-k8s-status.sh kubernetes
