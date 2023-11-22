### Building the application:
./mvnw clean install -DskipTests=true

### Pushing a docker image to ACR:
./script_push_docker_img.sh

### Getting access to Kubernetes after az login:
az aks get-credentials --name codehunters-training-aks --resource-group codehunters-training-components-rg

### Curl inside the cluster:
curl -X POST -H "Content-Type: application/json" -d @req.json http://10.1.100.166:8080/events

### Monitoring Commands
kubectl port-forward svc/kube-prometheus-kube-prome-prometheus 9090:9090 --namespace monitoring
kubectl port-forward svc/kube-prometheus-grafana 3000:80 --namespace monitoring

#### Grafana Login
admin / prom-operator or admin / admin