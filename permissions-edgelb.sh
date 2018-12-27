echo "--------  Edge LB permissions---------"
dcos security org service-accounts keypair edgelb-private-key.pem edgelb-public-key.pem
dcos security org service-accounts create -p edgelb-public-key.pem -d "edgelb service account" edgelb-principal
dcos security org service-accounts show edgelb-principal
dcos security secrets create-sa-secret --strict edgelb-private-key.pem edgelb-principal edgelb-secret
dcos security org groups add_user superusers edgelb-principal
rm -f edgelb-private-key.pem
rm -f edgelb-public-key.pem
