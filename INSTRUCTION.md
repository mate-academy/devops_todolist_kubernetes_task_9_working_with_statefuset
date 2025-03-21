Start the script:
```bash
sudo chmod +x bootstrap.sh
```

Then:

```
./bootstrap.sh
```
Then:
```
kubectl get statefulsets -n mysql
```

Then check logs:
```
kubectl logs -n mysql mysql-0
```
