#### argoCD Installation Steps

* Go to below URL and look for argoCD releases
https://github.com/argoproj/argo-cd/releases/


##### Login Details
User: admin
Pass: XXXXX

The default password for the "admin" account can be found from "secret" named argocd-initial-admin-secret in your Argo CD installation namespace. You can simply retrieve this password using kubectl:

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```