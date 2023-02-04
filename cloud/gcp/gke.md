# Google Kubernetes Engine (GKE)

GKE provides a **managed environment** for deploying, managing, and scaling your containerized applications using Google infrastructure. The GKE environment consists of multiple machines (Compute Engine instances) grouped together to form a cluster.


Cluster management features that Google Cloud provides
- Load-balancing
- Node pools
- Automatic scaling 
- Automatic upgrades
- Node auto repair
- Logging and monitoring

GKE provides **Autopilot** and **Standard** mode. GKE Autopilot provides a more managed Kubernetes experience. It implements many Kubernetes best practices by default and hence is recommended.

A *cluster* consists of multiple worker machines called *nodes* and at least one *cluster control plane machine*. You deploy to applications to cluster, and the applications run on the nodes.

GKE cluster has
- Deployment object to define your app
- Service object to define how to access your app
