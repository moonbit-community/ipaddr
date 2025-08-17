pub fn demo() -> Unit {
  // IPv4 demo
  let ipv4_addr = @lib.ipv4(192, 168, 1, 1)
  println("IPv4 address: " + @lib.format_ipv4(ipv4_addr))
  println("Is private: " + @lib.ipv4_is_private(ipv4_addr).to_string())
  
  // IPv4 prefix demo
  let prefix = @lib.ipv4_prefix(@lib.ipv4(192, 168, 1, 0), 24)
  let network = @lib.ipv4_prefix_network(prefix)
  let broadcast = @lib.ipv4_prefix_broadcast(prefix)
  println("Network: " + @lib.format_ipv4(network))
  println("Broadcast: " + @lib.format_ipv4(broadcast))
  println("Contains 192.168.1.1: " + @lib.ipv4_prefix_contains(prefix, ipv4_addr).to_string())
  
  // MAC demo
  let mac_addr = @lib.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  println("MAC address: " + @lib.format_mac(mac_addr))
  println("Is unicast: " + @lib.mac_is_unicast(mac_addr).to_string())
  println("Is global: " + @lib.mac_is_global(mac_addr).to_string())
}
