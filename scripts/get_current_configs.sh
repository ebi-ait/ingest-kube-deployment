# Deployment configs
kubectl apply view-last-applied deployment ingest-accessioner > $environment/deployments/ingest-accessioner.yml
kubectl apply view-last-applied deployment ingest-archiver > $environment/deployments/ingest-archiver.yml
kubectl apply view-last-applied deployment ingest-core > $environment/deployments/ingest-core.yml
kubectl apply view-last-applied deployment ingest-demo > $environment/deployments/ingest-demo.yml
kubectl apply view-last-applied deployment ingest-exporter > $environment/deployments/ingest-exporter.yml
kubectl apply view-last-applied deployment ingest-ontology > $environment/deployments/ingest-ontology.yml
kubectl apply view-last-applied deployment ingest-staging-manager > $environment/deployments/ingest-staging-manager.yml
kubectl apply view-last-applied deployment ingest-state-tracking > $environment/deployments/ingest-state-tracking.yml
kubectl apply view-last-applied deployment ingest-validator > $environment/deployments/ingest-validator.yml
kubectl apply view-last-applied deployment rabbit > $environment/deployments/rabbit.yml

# stateful set configs
kubectl apply view-last-applied statefulset mongo > $environment/stateful_sets/mongo.yml
kubectl apply view-last-applied statefulset redis > $environment/stateful_sets/redis.yml

# service configs
kubectl apply view-last-applied service ingest-core-service > $environment/services/ingest-core.yml
kubectl apply view-last-applied service ingest-demo-service > $environment/services/ingest-demo.yml
kubectl apply view-last-applied service ingest-ontology-service > $environment/services/ingest-ontology.yml
kubectl apply view-last-applied service mongo-service > $environment/services/mongo.yml
kubectl apply view-last-applied service rabbit-service > $environment/services/rabbit.yml
kubectl apply view-last-applied service redis-service > $environment/services/redis.yml
