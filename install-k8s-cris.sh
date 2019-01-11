#!/bin/bash

export MASTER=$1
export SERVICE_ACCOUNT=$2
ssh-add /Users/cristina/.ssh/mesosphere-shared-ec2.pem

if [ -z "$MASTER" ]; then
        echo Please provide Master IP address as first argument to script
        exit -1
fi

echo $(dcos config show core.dcos_url)
        dcos config set core.dcos_url https://$MASTER
        dcos config set core.ssl_verify false
        dcos cluster setup $(dcos config show core.dcos_url)
echo $(dcos cluster list)

        dcos package install --yes --cli dcos-enterprise-cli

echo "--------  To configure MKE permissions---------"
        ./permissions-mke.sh

echo "-------- To install MKE Service ---------"
				dcos package install --yes kubernetes --options=kubernetes-mke-options.json
        sleep 10
echo "--------  To install CLI ---------"
        dcos package install kubernetes --cli --yes



echo "--------  To configure $SERVICE_ACCOUNT service account ---------"
        ./permissions-kubernetes-cluster.sh

echo "--------  To install K8s CLUSTER_URL ---------"
				dcos kubernetes cluster create --options=kubernetes-cluster-options.json --yes

echo "--------  To check K8s cluser install ---------"
				./check-k8s-status.sh $SERVICE_ACCOUNT


echo "--------  To deploy EDGELB ---------"
    EDGELB="$(dcos task edgelb | wc -l)"
	if [ "$EDGELB" -lt "3" ]; then
	dcos package repo add --index=0 edgelb-aws https://downloads.mesosphere.com/edgelb/v1.0.2/assets/stub-universe-edgelb.json
	dcos package repo add --index=0 edgelb-pool-aws https://downloads.mesosphere.com/edgelb-pool/v1.0.2/assets/stub-universe-edgelb-pool.json
  ./permissions-edgelb.sh

  dcos package install --options=edgelb-options.json edgelb --yes
	dcos package install edgelb --cli --yes
	dcos package install edgelb-pool --cli --yes
	echo "Waiting for edgelb to come up ..."
	until dcos edgelb ping; do sleep 1; done


		dcos edgelb create edgelb-pool-k8s.json
		sleep 10
		echo $(dcos edgelb list)
	fi

echo

echo Determing public node ip...
export PUBLICNODEIP=$(dcos task exec -it edgelb-pool-0-server curl ifconfig.co)
echo Public node ip: $PUBLICNODEIP
export PUBLICURL=https://$PUBLICNODEIP
echo $PUBLICURL
echo ------------------

if [ ${#PUBLICNODEIP} -le 6 ] ;
then
	echo Can not find public node ip. JQ in path?  Also, you need to have added the pem for your nodes to your auth agent with the ssh-add command.
	exit -1
fi

# dcos kubernetes cluster kubeconfig \
#  --insecure-skip-tls-verify \
#  --context-name=$SERVICE_ACCOUNT \
#  --cluster-name=$SERVICE_ACCOUNT \
#  --apiserver-url=$PUBLICURL\:6443

#kubectl get nodes
#echo $(kubectl get nodes)

#kubectl proxy
#open http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

echo ------------------
