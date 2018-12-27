echo  $SERVICE_ACCOUNT
echo  "$SERVICE_ACCOUNT-priv.pem"
echo  "$SERVICE_ACCOUNT-pub.pem"

echo "--------  Keypairs Kubernetes Cluster---------"

dcos security org service-accounts keypair $SERVICE_ACCOUNT-priv.pem $SERVICE_ACCOUNT-pub.pem
dcos security org service-accounts create -p $SERVICE_ACCOUNT-pub.pem -d 'Service account for $SERVICE_ACCOUNT' $SERVICE_ACCOUNT
dcos security secrets create-sa-secret $SERVICE_ACCOUNT-priv.pem $SERVICE_ACCOUNT $SERVICE_ACCOUNT/sa



echo "--------  Permissions for Cluster1---------"
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:framework:role:$SERVICE_ACCOUNT-role create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:task:user:root create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:agent:task:user:root create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:reservation:role:$SERVICE_ACCOUNT-role create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:reservation:principal:$SERVICE_ACCOUNT delete
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:volume:role:$SERVICE_ACCOUNT-role create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:volume:principal:$SERVICE_ACCOUNT delete

dcos security org users grant $SERVICE_ACCOUNT dcos:secrets:default:/$SERVICE_ACCOUNT/* full
dcos security org users grant $SERVICE_ACCOUNT dcos:secrets:list:default:/$SERVICE_ACCOUNT read
dcos security org users grant $SERVICE_ACCOUNT dcos:adminrouter:ops:ca:rw full
dcos security org users grant $SERVICE_ACCOUNT dcos:adminrouter:ops:ca:ro full

dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:framework:role:slave_public/$SERVICE_ACCOUNT-role create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:framework:role:slave_public/$SERVICE_ACCOUNT-role read
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:reservation:role:slave_public/$SERVICE_ACCOUNT-role create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:volume:role:slave_public/$SERVICE_ACCOUNT-role create
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:master:framework:role:slave_public read
dcos security org users grant $SERVICE_ACCOUNT dcos:mesos:agent:framework:role:slave_public read



rm -f $SERVICE_ACCOUNT-priv.pem
rm -f $SERVICE_ACCOUNT-pub.pem
echo "--------  End of service-account script---------"
