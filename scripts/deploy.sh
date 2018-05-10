# Deployment configs
kubectl apply -f $environment/ingestion/deployments/ingest-accessioner.yml
kubectl apply -f $environment/ingestion/deployments/ingest-archiver.yml
kubectl apply -f $environment/ingestion/deployments/ingest-core.yml
kubectl apply -f $environment/ingestion/deployments/ingest-demo.yml
kubectl apply -f $environment/ingestion/deployments/ingest-exporter.yml
kubectl apply -f $environment/ingestion/deployments/ingest-ontology.yml
kubectl apply -f $environment/ingestion/deployments/ingest-staging-manager.yml
kubectl apply -f $environment/ingestion/deployments/ingest-state-tracking.yml
kubectl apply -f $environment/ingestion/deployments/ingest-validator.yml
kubectl apply -f $environment/ingestion/deployments/rabbit.yml

# stateful set configs
kubectl apply -f $environment/ingestion/stateful_sets/mongo.yml
kubectl apply -f $environment/ingestion/stateful_sets/redis.yml

# service configs
kubectl apply -f $environment/ingestion/services/ingest-core.yml
kubectl apply -f $environment/ingestion/services/ingest-demo.yml
kubectl apply -f $environment/ingestion/services/ingest-ontology.yml
kubectl apply -f $environment/ingestion/services/mongo.yml
kubectl apply -f $environment/ingestion/services/rabbit.yml
