test "demo" {
  // IPv4 demo
  let ipv4_addr = ipv4(192, 168, 1, 1)
  inspect(format_ipv4(ipv4_addr), content="192.168.1.1")
  inspect(ipv4_is_private(ipv4_addr), content="true")
  
  // IPv4 prefix demo
  let prefix = ipv4_prefix(ipv4(192, 168, 1, 0), 24)
  let network = ipv4_prefix_network(prefix)
  let broadcast = ipv4_prefix_broadcast(prefix)
  inspect(format_ipv4(network), content="192.168.1.0")
  inspect(format_ipv4(broadcast), content="192.168.1.255")
  inspect(ipv4_prefix_contains(prefix, ipv4_addr), content="true")
  
  // MAC demo
  let mac_addr = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  inspect(format_mac(mac_addr), content="00:11:22:33:44:55")
  inspect(mac_is_unicast(mac_addr), content="true")
  inspect(mac_is_global(mac_addr), content="true")
}
