kubectl create configmap kong-plugin-myheader --from-file=src -n kong

# Test
kubectl apply -f plugin-myheader.yaml