data "ibm_resource_group" "resource_group" {
  name = "default"
}
resource "ibm_container_cluster" "tfcluster" {
  name            = "tfclusterdoc"
  datacenter      = "dal10"
  machine_type    = "b3c.4x16"
  hardware        = "shared"
  public_vlan_id  = "2234945"
  private_vlan_id = "2234947"

  kube_version = "1.21.9"

  default_pool_size = 3

  public_service_endpoint  = "true"
  private_service_endpoint = "true"

  resource_group_id = data.ibm_resource_group.resource_group.id
}
