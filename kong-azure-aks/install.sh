 helm repo add kong https://charts.konghq.com
 helm repo update

# Helm 3
kubectl create namespace kong
helm install kong kong/kong  -f values.yaml -n kong --version 2.3.0
helm upgrade kong kong/kong  -f values.yaml -n kong --version 2.3.0