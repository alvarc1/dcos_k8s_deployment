
kubectl create -f namespace.yaml
kubectl config set-context $(kubectl config current-context) --namespace=prod-microservices-$PATH
sleep 5
open $CLUSTER_URL/service/kubernetes-proxy/
kubectl create -f k8s.tmp
until $(curl --output /dev/null --silent --head --fail http://$PUBLICNODEIP:18080); do
    printf '.'
    sleep 5
done
echo
echo
echo I am opening the UI now but please wait with hitting the Dashboard before I am completely finsihed. You might also need to reload the UI in the browser.
echo
sleep 1

open http://$PUBLICNODEIP:18080
./permissions-k8s.sh config.json
./addons-k8s.sh $PUBLICNODEIP $PATH $MASTERIP

--------  Permissions ---------

NOTES
IAM backend reported error `RequestError`: URL [https://34.221.106.78/acs/api/v1/acls/dcos:mesos:master:task:user:root/users/kubernetes-cluster1/create] is unreachable.
