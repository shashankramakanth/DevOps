**Overview**

- Peer 2 VNETS

┌─────────────────┐         ┌─────────────────┐
│   VNet A        │◄────────┤   VNet B        │
│   10.0.0.0/16   │ Peering │   10.1.0.0/16   │
│                 │◄────────┤                 │
└─────────────────┘         └─────────────────┘

- Create VMs in both the VNETs and verify communication

- Add a **Provisioner** block to one of the VMs and run ```sudo apt-get update -y ```

