resource "latitudesh_server" "server" {
  hostname         = "rpc.node"
  operating_system = "ubuntu_20_04_x64_lts" # Matches what the required OS for Solana is
  plan             = var.plan
  project          = var.project
  billing          = "hourly"
  site             = var.region
  ssh_keys         = [latitudesh_ssh_key.ssh_key.id]
}
