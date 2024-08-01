resource "latitudesh_ssh_key" "ssh_key" {
  project    = var.project
  name       = "rpc.ssh"
  public_key = var.ssh_public_key
}
