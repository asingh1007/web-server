module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version                    = "12.0.0"
  project_id                 = var.project_id
  name                       = "demo-cluster"
  region                     = "us-central1"
  zones                      = ["us-central1-c"]
  network                    = module.vpc.network_name
  subnetwork                 = "demo-subnet"
  ip_range_pods              = "secondary-pod-name"
  ip_range_services          = "secondary-range-name"
  horizontal_pod_autoscaling = "true"
  network_policy             = "false"
  kubernetes_version         = "1.18.16-gke.502"
  default_max_pods_per_node  = 16
  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      min_count          = 2
      max_count          = 20
      local_ssd_count    = 0
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
