# Prints the IPv4 of the server we just created when the deploy
# is finished on the terminal
output "server-ip" {
  value = latitudesh_server.server.primary_ipv4
}
