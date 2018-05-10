# Deployment configs
kubectl apply view-last-applied deployment ingest-accessioner > $environment/ingestion/deployments/ingest-accessioner.yml
kubectl apply view-last-applied deployment ingest-archiver > $environment/ingestion/deployments/ingest-archiver.yml
kubectl apply view-last-applied deployment ingest-core > $environment/ingestion/deployments/ingest-core.yml
kubectl apply view-last-applied deployment ingest-demo > $environment/ingestion/deployments/ingest-demo.yml
kubectl apply view-last-applied deployment ingest-exporter > $environment/ingestion/deployments/ingest-exporter.yml
kubectl apply view-last-applied deployment ingest-ontology > $environment/ingestion/deployments/ingest-ontology.yml
kubectl apply view-last-applied deployment ingest-staging-manager > $environment/ingestion/deployments/ingest-staging-manager.yml
kubectl apply view-last-applied deployment ingest-state-tracking > $environment/ingestion/deployments/ingest-state-tracking.yml
kubectl apply view-last-applied deployment ingest-validator > $environment/ingestion/deployments/ingest-validator.yml
kubectl apply view-last-applied deployment rabbit > $environment/ingestion/deployments/rabbit.yml

# stateful set configs
kubectl apply view-last-applied statefulset mongo > $environment/ingestion/stateful_sets/mongo.yml
kubectl apply view-last-applied statefulset redis > $environment/ingestion/stateful_sets/redis.yml

# service configs
kubectl apply view-last-applied service ingest-core-service > $environment/ingestion/services/ingest-core.yml
kubectl apply view-last-applied service ingest-demo-service > $environment/ingestion/services/ingest-demo.yml
kubectl apply view-last-applied service ingest-ontology-service > $environment/ingestion/services/ingest-ontology.yml
kubectl apply view-last-applied service mongo-service > $environment/ingestion/services/mongo.yml
kubectl apply view-last-applied service rabbit-service > $environment/ingestion/services/rabbit.yml
kubectl apply view-last-applied service redis-service > $environment/ingestion/services/redis.yml
