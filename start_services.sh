kubectl apply -f deployment.yaml 

minikube service saleor-api -n saleor &                                                 
minikube service saleor-dashboard -n saleor &
minikube service postgres -n saleor &
minikube service redis -n saleor &
minikube service jaeger -n saleor &
minikube service mailpit -n saleor



