echo  $SERVICE_ACCOUNT

echo "--------  Keypairs Kubernetes Service (MKE)---------"
dcos security org service-accounts keypair private-key.pem public-key.pem
dcos security org service-accounts create -p public-key.pem -d 'Kubernetes service account' $SERVICE_ACCOUNT
dcos security secrets create-sa-secret private-key.pem kubernetes kubernetes/sa
rm -f private-key.pem
rm -f public-key.pem

echo "--------  Permissions to MKE---------"

dcos security org users grant kubernetes dcos:mesos:master:reservation:role:kubernetes-role create
dcos security org users grant kubernetes dcos:mesos:master:framework:role:kubernetes-role create
dcos security org users grant kubernetes dcos:mesos:master:task:user:nobody create

echo "--------  End of MKE permissions script---------"
+
