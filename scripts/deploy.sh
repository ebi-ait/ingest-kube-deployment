# Deployment configs
kubectl apply -f $environment/deployments/ingest-accessioner.yml
kubectl apply -f $environment/deployments/ingest-archiver.yml
kubectl apply -f $environment/deployments/ingest-core.yml
kubectl apply -f $environment/deployments/ingest-demo.yml
kubectl apply -f $environment/deployments/ingest-exporter.yml
kubectl apply -f $environment/deployments/ingest-ontology.yml
kubectl apply -f $environment/deployments/ingest-staging-manager.yml
kubectl apply -f $environment/deployments/ingest-state-tracking.yml
kubectl apply -f $environment/deployments/ingest-validator.yml
kubectl apply -f $environment/deployments/rabbit.yml

# stateful set configs
kubectl apply -f $environment/stateful_sets/mongo.yml
kubectl apply -f $environment/stateful_sets/redis.yml

# service configs
kubectl apply -f $environment/services/ingest-core.yml
kubectl apply -f $environment/services/ingest-demo.yml
kubectl apply -f $environment/services/ingest-ontology.yml
kubectl apply -f $environment/services/mongo.yml
kubectl apply -f $environment/services/rabbit.yml
