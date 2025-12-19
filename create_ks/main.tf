
data "ibm_resource_group" "resource_group" {
  name = "default"
}

# IBM Cloud Kubernetes Service cluster
resource "ibm_container_cluster" "tfcluster" {
  name            = "tfclusterdoc"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  private_vlan_id = "3527884"
  public_vlan_id  = "3527882"

  kube_version = "1.33.6"

  default_pool_size = 3

  public_service_endpoint  = "true"
  private_service_endpoint = "true"

  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "dal12" {
  cluster           = ibm_container_cluster.tfcluster.id
  worker_pool       = ibm_container_cluster.tfcluster.worker_pools.0.id
  zone              = "dal12"
  private_vlan_id   = "3527888"
  public_vlan_id    = "3527886"
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "dal13" {
  cluster           = ibm_container_cluster.tfcluster.id
  worker_pool       = ibm_container_cluster.tfcluster.worker_pools.0.id
  zone              = "dal13"
  private_vlan_id   = "3527892"
  public_vlan_id    = "3527890"
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool" "workerpool" {
  worker_pool_name = "tf-workerpool"
  machine_type     = "u3c.2x4"
  cluster          = ibm_container_cluster.tfcluster.id
  size_per_zone    = 2
  hardware         = "shared"

  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "tfwp-dal10" {
  cluster         = ibm_container_cluster.tfcluster.id
  worker_pool     = element(split("/", ibm_container_worker_pool.workerpool.id), 1)
  zone            = "dal10"
  private_vlan_id = "3527884"
  public_vlan_id  = "3527882"

  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "tfwp-dal12" {
  cluster           = ibm_container_cluster.tfcluster.id
  worker_pool       = element(split("/", ibm_container_worker_pool.workerpool.id), 1)
  zone              = "dal12"
  private_vlan_id   = "3527888"
  public_vlan_id    = "3527886"
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_container_worker_pool_zone_attachment" "tfwp-dal13" {
  cluster           = ibm_container_cluster.tfcluster.id
  worker_pool       = element(split("/", ibm_container_worker_pool.workerpool.id), 1)
  zone              = "dal13"
  private_vlan_id   = "3527892"
  public_vlan_id    = "3527890"
  resource_group_id = data.ibm_resource_group.resource_group.id
}