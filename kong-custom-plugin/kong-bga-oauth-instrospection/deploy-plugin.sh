# Create Configmap
kubectl create configmap oauthintrospection --from-file=src -n kong
kubectl apply -f plugin-custom-bga-oauth.yaml