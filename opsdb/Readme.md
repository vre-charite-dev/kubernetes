### Deploy and configure PostgreSQL
Apply the PersistentVolumeClaims, secret, and deployment in /VRE/kubernetes/opsdb:

```bash
kubectl apply -f  new-datadir-postgres-0-pvc.yaml -n utility
kubectl apply -f  new-datadir-opsdb-0-pvc.yaml -n utility
kubectl apply -f  credential.yaml -n utility

# If the config map is not created create it from the scripts directory
kubectl create configmap --from-file=./scripts init-opsdb-configmap -n utility -o yaml > init-opsdb-configmap.yaml

# Otherwise apply the configmap
kubectl apply -f init-opsdb-configmap.yaml -n utility


kubectl apply -f deployment.yaml -n utility

```