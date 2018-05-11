export environment=dev
kubectx parth-ingest-us-east-1.k8s.local
kubens dev-environment
sh scripts/get_current_configs.sh

export environment=integration
kubectx parth-ingest-us-east-1.k8s.local
kubens integration-environment
sh scripts/get_current_configs.sh

export environment=staging
kubectx parth-ingest-us-east-1.k8s.local
kubens staging-environment
sh scripts/get_current_configs.sh

export environment=prod
kubectx parth-preview-ingest.k8s.local
kubens prod-environment
sh scripts/get_current_configs.sh
