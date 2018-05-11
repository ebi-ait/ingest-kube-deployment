# Deployment configs
kubectl apply view-last-applied deployment ingest-accessioner > $environment/deployments/ingest-accessioner-deploy.yml
kubectl apply view-last-applied deployment ingest-archiver > $environment/deployments/ingest-archiver-deploy.yml
kubectl apply view-last-applied deployment ingest-core > $environment/deployments/ingest-core-deploy.yml
kubectl apply view-last-applied deployment ingest-demo > $environment/deployments/ingest-demo-deploy.yml
kubectl apply view-last-applied deployment ingest-exporter > $environment/deployments/ingest-exporter-deploy.yml
kubectl apply view-last-applied deployment ingest-ontology > $environment/deployments/ingest-ontology-deploy.yml
kubectl apply view-last-applied deployment ingest-staging-manager > $environment/deployments/ingest-staging-manager-deploy.yml
kubectl apply view-last-applied deployment ingest-state-tracking > $environment/deployments/ingest-state-tracking-deploy.yml
kubectl apply view-last-applied deployment ingest-validator > $environment/deployments/ingest-validator-deploy.yml
kubectl apply view-last-applied deployment rabbit > $environment/deployments/rabbit-deploy.yml

# stateful set configs
kubectl apply view-last-applied statefulset mongo > $environment/stateful_sets/mongo-stateful-deploy.yml
kubectl apply view-last-applied statefulset redis > $environment/stateful_sets/redis-stateful-deploy.yml

# service configs
kubectl apply view-last-applied service ingest-core-service > $environment/services/ingest-core-service.yml
kubectl apply view-last-applied service ingest-demo-service > $environment/services/ingest-demo-service.yml
kubectl apply view-last-applied service ingest-ontology-service > $environment/services/ingest-ontology-service.yml
kubectl apply view-last-applied service mongo-service > $environment/services/mongo-service.yml
kubectl apply view-last-applied service rabbit-service > $environment/services/rabbit-service.yml
kubectl apply view-last-applied service redis-service > $environment/services/redis-service.yml
