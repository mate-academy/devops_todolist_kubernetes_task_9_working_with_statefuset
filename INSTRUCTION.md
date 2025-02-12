## Create cluster from kind:
```bash
./kind create cluster --config ./.infrastructure/cluster.yml
```
## To run infrastructure(kustomization):
```bash
kubectl apply -k .\.infrastructure
```