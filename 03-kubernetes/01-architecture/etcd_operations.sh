#create a test pod
kubectl run test-pod --image=nginx --restart=Never

#get details of the pod from etcd
k exec -n kube-system etcd-my-cka-cluster01-control-plane -- etcdctl --endpoints=https://172.21.0.3:2379 --cert=/etc/kubernetes/pki/etcd/server.crt --cacert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/server.key get /registry/pods/default/test-pod


