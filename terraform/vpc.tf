module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "2.5"

  project_id              = var.project_id
  network_name            = "demo-vpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = "false"

  subnets = [
    {
      subnet_name   = "demo-subnet"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    "demo-subnet" = [
      {
        range_name    = "secondary-pod-name"
        ip_cidr_range = "10.0.1.0/24"
      },
      {
        range_name    = "secondary-range-name"
        ip_cidr_range = "10.0.2.0/24"
      }
    ]
  }
}