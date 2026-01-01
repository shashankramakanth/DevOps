- etcd
    - Distributed & Persistent key-value store: Contains all the data about a cluster i.e., pods, deployments, configs, secrets
    - Uses raft concensus algorithm to maintain consistency
    - How is it persistent:
        - Runs in a cluster of nodes(3, 5, or 7)- chooses odd number of nodes to overcome split-brain scenario
        - All nodes hold of a copy of the data and in sync
        - Uses Write-Ahead log - Every change is first written to the disk
        - Snapshots & Backups
			- In case of a single-node cluster, etcd is still persistent but not highly available/redundant. If there an issue with node disk or etcd is corrupted, cluster information is lost
			- Every service and related information is stored under `/registry`

```bash
			#set etcd API version
			export ETCDCTL_API=3
			
			#ETC configuration location
			/etc/kubernetes/manifests/etcd.yaml
```

### Take a snapshot

```bash
ETCDCTL_API=3 etcdctl snapshot save <snapshot-save-location.db> \
    --endpoints=<LISTEN_CLIENT_URLS> \
    --cert=<CERT_FILE> \
    --cacert=<TRUSTED_CA_FILE> \
    --key=<KEY_FILE>

```

### Restore

```bash

#Restore to a new directory
ETCDCTL_API=3 etcdctl snapshot restore <saved-snapshot-location.db> \
    --data-dir=<new-location-for-snapshot>

#update etcd static pod manifest
vi /etc/kubernetes/manifests/etcd.yaml
#Change: --data-dir=/var/lib/etcd
#To:     --data-dir=/var/lib/etcd-restore

#Update hostPath volume
#volumes:
# - hostPath:
#    path: /var/lib/etcd-restore
#    type: DirectoryOrCreate
#   name: etcd-data

#Wait for etcd pod to restart

#Verify
kubectl get pods -n kube-system

```
