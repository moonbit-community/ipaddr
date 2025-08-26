///|
test "demo" {
  // IPv4 demo
  let ipv4_addr = ipv4(192, 168, 1, 1)
  inspect(ipv4_addr.format(), content="192.168.1.1")
  inspect(ipv4_addr.is_private(), content="true")

  // IPv4 prefix demo
  let prefix = ipv4_prefix(ipv4(192, 168, 1, 0), 24)
  let network = prefix.network()
  let broadcast = prefix.broadcast()
  inspect(network.format(), content="192.168.1.0")
  inspect(broadcast.format(), content="192.168.1.255")
  inspect(prefix.contains(ipv4_addr), content="true")

  // MAC demo
  let mac_addr = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  inspect(mac_addr.format(), content="00:11:22:33:44:55")
  inspect(mac_addr.is_unicast(), content="true")
  inspect(mac_addr.is_global(), content="true")
}
