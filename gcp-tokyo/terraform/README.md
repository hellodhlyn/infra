# gke-tokyo

### Prepare

```shell
gcloud init
gcloud auth application-default login

gcloud components install gke-gcloud-auth-plugin
gcloud container clusters get-credentials <cluster_name> --zone=asia-northeast1
```
