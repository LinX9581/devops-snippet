# use cmd

kubectl create configmap pg-connect \
--from-literal=host=127.0.0.1 \
--from-literal=port=5432

* use file
kubectl create configmap redis-config --from-file=my-redis.conf

# use yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: initdb-kv-yaml
  labels:
    app: db
data:
  PG_USER: postgres
  PG_PASSWORD: postgres