// Simple tests for the basic ipaddr functionality

test "ipv4_basic_construction" {
  let addr = ipv4(192, 168, 1, 1)
  if addr.a != 192 { fail("Expected a=192") }
  if addr.b != 168 { fail("Expected b=168") }
  if addr.c != 1 { fail("Expected c=1") }
  if addr.d != 1 { fail("Expected d=1") }
}

test "ipv4_formatting" {
  let addr = ipv4(192, 168, 1, 1)
  let formatted = format_ipv4(addr)
  if formatted != "192.168.1.1" { fail("IPv4 formatting failed") }
}

test "ipv4_validation" {
  let valid_addr = ipv4(192, 168, 1, 1)
  let invalid_addr = ipv4(256, 168, 1, 1)
  
  if not(is_valid_ipv4(valid_addr)) { fail("Valid IPv4 should be valid") }
  if is_valid_ipv4(invalid_addr) { fail("Invalid IPv4 should be invalid") }
}

test "ipv4_int_conversion" {
  let addr = ipv4(192, 168, 1, 1)
  let int_val = ipv4_to_int(addr)
  let converted_back = int_to_ipv4(int_val)
  
  if converted_back.a != addr.a { fail("Round trip conversion failed for a") }
  if converted_back.b != addr.b { fail("Round trip conversion failed for b") }
  if converted_back.c != addr.c { fail("Round trip conversion failed for c") }
  if converted_back.d != addr.d { fail("Round trip conversion failed for d") }
}

test "ipv4_classification" {
  // Private addresses
  if not(ipv4_is_private(ipv4(10, 0, 0, 1))) { fail("10.0.0.1 should be private") }
  if not(ipv4_is_private(ipv4(172, 16, 0, 1))) { fail("172.16.0.1 should be private") }
  if not(ipv4_is_private(ipv4(192, 168, 1, 1))) { fail("192.168.1.1 should be private") }
  if ipv4_is_private(ipv4(8, 8, 8, 8)) { fail("8.8.8.8 should not be private") }
  
  // Loopback
  if not(ipv4_is_loopback(ipv4(127, 0, 0, 1))) { fail("127.0.0.1 should be loopback") }
  if ipv4_is_loopback(ipv4(192, 168, 1, 1)) { fail("192.168.1.1 should not be loopback") }
  
  // Multicast
  if not(ipv4_is_multicast(ipv4(224, 0, 0, 1))) { fail("224.0.0.1 should be multicast") }
  if ipv4_is_multicast(ipv4(192, 168, 1, 1)) { fail("192.168.1.1 should not be multicast") }
  
  // Broadcast
  if not(ipv4_is_broadcast(ipv4(255, 255, 255, 255))) { fail("255.255.255.255 should be broadcast") }
  if ipv4_is_broadcast(ipv4(192, 168, 1, 255)) { fail("192.168.1.255 should not be broadcast") }
}

test "ipv4_prefix_operations" {
  let prefix = ipv4_prefix(ipv4(192, 168, 1, 0), 24)
  let addr1 = ipv4(192, 168, 1, 1)
  let addr2 = ipv4(192, 168, 1, 255)
  let addr3 = ipv4(192, 168, 2, 1)
  
  if not(ipv4_prefix_contains(prefix, addr1)) { fail("192.168.1.1 should be in 192.168.1.0/24") }
  if not(ipv4_prefix_contains(prefix, addr2)) { fail("192.168.1.255 should be in 192.168.1.0/24") }
  if ipv4_prefix_contains(prefix, addr3) { fail("192.168.2.1 should not be in 192.168.1.0/24") }
  
  let network = ipv4_prefix_network(prefix)
  let broadcast = ipv4_prefix_broadcast(prefix)
  
  if network.a != 192 || network.b != 168 || network.c != 1 || network.d != 0 {
    fail("Network address should be 192.168.1.0")
  }
  
  if broadcast.a != 192 || broadcast.b != 168 || broadcast.c != 1 || broadcast.d != 255 {
    fail("Broadcast address should be 192.168.1.255")
  }
}

test "mac_basic_construction" {
  let addr = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  if addr.b0 != 0x00 { fail("Expected b0=0x00") }
  if addr.b1 != 0x11 { fail("Expected b1=0x11") }
  if addr.b5 != 0x55 { fail("Expected b5=0x55") }
}

test "mac_formatting" {
  let addr = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let formatted = format_mac(addr)
  if formatted != "00:11:22:33:44:55" { fail("MAC formatting failed") }
}

test "mac_classification" {
  // Broadcast
  let broadcast = mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
  if not(mac_is_broadcast(broadcast)) { fail("ff:ff:ff:ff:ff:ff should be broadcast") }
  
  // Multicast (first bit set)
  let multicast = mac(0x01, 0x00, 0x5E, 0x00, 0x00, 0x01)
  if not(mac_is_multicast(multicast)) { fail("01:00:5e:00:00:01 should be multicast") }
  if mac_is_unicast(multicast) { fail("01:00:5e:00:00:01 should not be unicast") }
  
  // Unicast (first bit clear)
  let unicast = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  if not(mac_is_unicast(unicast)) { fail("00:11:22:33:44:55 should be unicast") }
  if mac_is_multicast(unicast) { fail("00:11:22:33:44:55 should not be multicast") }
  
  // Local (second bit set)
  let local_mac = mac(0x02, 0x11, 0x22, 0x33, 0x44, 0x55)
  if not(mac_is_local(local_mac)) { fail("02:11:22:33:44:55 should be local") }
  if mac_is_global(local_mac) { fail("02:11:22:33:44:55 should not be global") }
  
  // Global (second bit clear)
  let global = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  if not(mac_is_global(global)) { fail("00:11:22:33:44:55 should be global") }
  if mac_is_local(global) { fail("00:11:22:33:44:55 should not be local") }
}

test "mac_oui" {
  let addr = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let (oui0, oui1, oui2) = mac_oui(addr)
  if oui0 != 0x00 { fail("Expected oui0=0x00") }
  if oui1 != 0x11 { fail("Expected oui1=0x11") }
  if oui2 != 0x22 { fail("Expected oui2=0x22") }
}

test "mac_int_conversion" {
  let addr = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let int_val = mac_to_int(addr)
  let converted_back = int_to_mac(int_val)
  
  // Note: int conversion only preserves the lower 4 bytes (b2-b5)
  if converted_back.b2 != addr.b2 { fail("Round trip conversion failed for b2") }
  if converted_back.b3 != addr.b3 { fail("Round trip conversion failed for b3") }
  if converted_back.b4 != addr.b4 { fail("Round trip conversion failed for b4") }
  if converted_back.b5 != addr.b5 { fail("Round trip conversion failed for b5") }
}