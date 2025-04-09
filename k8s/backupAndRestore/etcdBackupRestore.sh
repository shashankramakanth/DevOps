#Save an etcd snapshot
root@controlplane:~# ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db

Snapshot saved at /opt/snapshot-pre-boot.db
root@controlplane:~#

#Restore an etcd snapshot
ETCDCTL_API=3 etcdctl --data-dir /var/lib/etcd-from-backup snapshot restore /opt/snapshot-pre-boot.db

#Note: In this case, we are restoring the snapshot to a different directory 
#but in the same server where we took the backup (the controlplane node) 
#As a result, the only required option for the restore command is the --data-dir.


#We have now restored the etcd snapshot to a new path on the controlplane - /var/lib/etcd-from-backup, 
#so, the only change to be made in the YAML file, 
#is to change the hostPath for the volume called etcd-data from old directory (/var/lib/etcd) to the new directory (/var/lib/etcd-from-backup).

  volumes:
  - hostPath:
      path: /var/lib/etcd-from-backup
      type: DirectoryOrCreate
    name: etcd-data