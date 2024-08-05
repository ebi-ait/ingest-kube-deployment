#!/bin/bash

prometheus_IP=$(kubectl get svc -n gitlab-managed-apps -o jsonpath="{.items[?(@.metadata.name=='prometheus-prometheus-server')].spec.clusterIP}")

login_username=$(kubectl get secret aws-keys -o jsonpath="{.data.grafana-admin-username}" | base64 --decode)
login_password=$(kubectl get secret aws-keys -o jsonpath="{.data.grafana-admin-password}" | base64 --decode)
login_url="https://monitoring.ingest.${DEPLOYMENT_STAGE}.archive.data.humancellatlas.org"
dashboard_config_map="helm-charts/ingest-monitoring/templates/ingest-dashboard-configmap.yaml"

if [ $DEPLOYMENT_STAGE == "prod" ]
then
    login_url="https://monitoring.ingest.archive.data.humancellatlas.org"
fi

source ../config/environment_$DEPLOYMENT_STAGE

# Move JSON dashboard models into a configmap
# This is needed since the dashboard has to be a configmap but it is easier to store them as a JSON file
tmp_path='./tmp-dashboard.json'

# 1. Copy JSON dashboard file
cp helm-charts/ingest-monitoring/dashboards/ingest-monitoring.json $tmp_path

# 2. Replace <ENV>-environment with {{ .Values.environment }} so it is properly replaced with the environment in the values/<ENVIRONMENT.yaml> file
sed -i .bak -E "s/(dev|prod|staging)-environment/{{ .Values.environment }}/" $tmp_path

# 3. Replace {{ deployment }} with {{ "{{" }} deployment {{ "}}" }} so it is properly escaped in the YAML file
sed -i .bak 's/{{ deployment }}/{{ "{{" }} deployment {{ "}}" }}/' $tmp_path

# 4. Add proper indentation for configmap
sed -i .bak -E 's/^/     /'  $tmp_path

# 5. Create the configmap
echo '{{- template "ingest-monitoring.dashboardConfigMapHeader" }}' > $dashboard_config_map

# 6. Append the dashboard JSON to the config map
cat $tmp_path >> $dashboard_config_map


if [[ $* == '--upgrade' ]]
then
    echo "Performing upgrade..."
    helm upgrade ingest-monitoring helm-charts/ingest-monitoring\
        --set prometheusIP=$prometheus_IP\
        --values helm-charts/ingest-monitoring/values.yaml\
        --values helm-charts/ingest-monitoring/environments/$DEPLOYMENT_STAGE.yaml\
        --install
else
    helm upgrade ingest-monitoring helm-charts/ingest-monitoring\
        --set prometheusIP=$prometheus_IP\
        --values helm-charts/ingest-monitoring/values.yaml\
        --values helm-charts/ingest-monitoring/environments/$DEPLOYMENT_STAGE.yaml\
        --force --install
fi

# Remove the temporarily created config map and JSON file
rm $dashboard_config_map
rm $tmp_path



echo "Monitoring deployed!"
echo "===================="
echo "Login at: ${login_url}"
echo "Admin username: ${login_username}"
echo "Admin password: ${login_password}"
