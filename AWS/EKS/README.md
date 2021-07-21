# How to connect to EKS Cluster

1. use the AWS profile that got created EKS cluster

```
export AWS_PROFILE=<profile-name>
```

2. Run below command to get the kube-config into local to connect to the EKS cluster

```
aws eks --region region update-kubeconfig --name cluster_name --kubeconfig ~/.kube/<my-cluster-config>
```
#### Note: 
* Replace region with your AWS Region. Replace cluster_name with your cluster name.


3. Once you get the kubeConfig generated, use the below command to connect to cluster

```
export KUBECONFIG=~/.kube/<my-cluster-config>
kubectl config set-context <context-name> --cluster <cluster-arn> --user <cluster-user-arn> --namespace default
```

4. Once above is set, you can list the pods using below command

```
kubectl get pods
```




