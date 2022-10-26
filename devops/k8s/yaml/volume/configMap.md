
https://ithelp.ithome.com.tw/articles/10196153
# use cmd

kubectl create configmap pg-connect \
--from-literal=host=127.0.0.1 \
--from-literal=port=5432

* use file
kubectl create configmap env-config --from-file=env.conf

env.conf
mysqlaccount docker
mysqlpw 00000000

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

# get
kubectl get configmap

# update
kubectl edit configmap nodejs-config
更改後 pod 10秒後才會吃到