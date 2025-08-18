// Simplified IP address library for MoonBit
// This is a basic implementation focusing on core functionality

// IPv4 address representation
pub struct Ipv4 {
  a : Int
  b : Int  
  c : Int
  d : Int
} derive(Eq, Compare, Show)

// IPv4 constructor
pub fn ipv4(a : Int, b : Int, c : Int, d : Int) -> Ipv4 {
  { a, b, c, d }
}

// Format IPv4 address to string
pub fn format_ipv4(addr : Ipv4) -> String {
  "\{addr.a}.\{addr.b}.\{addr.c}.\{addr.d}"
}

// Simple IPv4 validation
pub fn is_valid_ipv4_octet(n : Int) -> Bool {
  n >= 0 && n <= 255
}

// Check if IPv4 address is valid
pub fn is_valid_ipv4(addr : Ipv4) -> Bool {
  is_valid_ipv4_octet(addr.a) && 
  is_valid_ipv4_octet(addr.b) && 
  is_valid_ipv4_octet(addr.c) && 
  is_valid_ipv4_octet(addr.d)
}

// Convert IPv4 address to 32-bit integer (network byte order)
pub fn ipv4_to_int(addr : Ipv4) -> Int {
  (addr.a << 24) | (addr.b << 16) | (addr.c << 8) | addr.d
}

// Convert 32-bit integer to IPv4 address (network byte order)
pub fn int_to_ipv4(n : Int) -> Ipv4 {
  let a = (n >> 24) & 0xFF
  let b = (n >> 16) & 0xFF
  let c = (n >> 8) & 0xFF
  let d = n & 0xFF
  ipv4(a, b, c, d)
}

// Check if IPv4 address is private (RFC 1918)
pub fn ipv4_is_private(addr : Ipv4) -> Bool {
  // 10.0.0.0/8
  if addr.a == 10 {
    return true
  }
  // 172.16.0.0/12
  if addr.a == 172 && addr.b >= 16 && addr.b <= 31 {
    return true
  }
  // 192.168.0.0/16
  if addr.a == 192 && addr.b == 168 {
    return true
  }
  false
}

// Check if IPv4 address is loopback (127.0.0.0/8)
pub fn ipv4_is_loopback(addr : Ipv4) -> Bool {
  addr.a == 127
}

// Check if IPv4 address is multicast (224.0.0.0/4)
pub fn ipv4_is_multicast(addr : Ipv4) -> Bool {
  addr.a >= 224 && addr.a <= 239
}

// Check if IPv4 address is broadcast (255.255.255.255)
pub fn ipv4_is_broadcast(addr : Ipv4) -> Bool {
  addr.a == 255 && addr.b == 255 && addr.c == 255 && addr.d == 255
}

// IPv4 CIDR prefix
pub struct Ipv4Prefix {
  addr : Ipv4
  prefix_len : Int
} derive(Eq, Compare, Show)

// IPv4 prefix constructor
pub fn ipv4_prefix(addr : Ipv4, prefix_len : Int) -> Ipv4Prefix {
  { addr, prefix_len }
}

// Check if an IPv4 address is in a given prefix/subnet
pub fn ipv4_prefix_contains(prefix : Ipv4Prefix, addr : Ipv4) -> Bool {
  if prefix.prefix_len == 0 {
    return true
  }
  
  let prefix_int = ipv4_to_int(prefix.addr)
  let addr_int = ipv4_to_int(addr)
  let mask = (0xFFFFFFFF << (32 - prefix.prefix_len)) & 0xFFFFFFFF
  
  (prefix_int & mask) == (addr_int & mask)
}

// Get the network address for a given IPv4 prefix
pub fn ipv4_prefix_network(prefix : Ipv4Prefix) -> Ipv4 {
  if prefix.prefix_len == 0 {
    return ipv4(0, 0, 0, 0)
  }
  
  let addr_int = ipv4_to_int(prefix.addr)
  let mask = (0xFFFFFFFF << (32 - prefix.prefix_len)) & 0xFFFFFFFF
  let network_int = addr_int & mask
  
  int_to_ipv4(network_int)
}

// Get the broadcast address for a given IPv4 prefix
pub fn ipv4_prefix_broadcast(prefix : Ipv4Prefix) -> Ipv4 {
  if prefix.prefix_len == 0 {
    return ipv4(255, 255, 255, 255)
  }
  
  let addr_int = ipv4_to_int(prefix.addr)
  let mask = (0xFFFFFFFF << (32 - prefix.prefix_len)) & 0xFFFFFFFF
  let broadcast_int = addr_int | (mask.lnot() & 0xFFFFFFFF)
  
  int_to_ipv4(broadcast_int)
}

// MAC address (6 bytes)
pub struct Mac {
  b0 : Int
  b1 : Int
  b2 : Int
  b3 : Int
  b4 : Int
  b5 : Int
} derive(Eq, Compare, Show)

// MAC constructor
pub fn mac(b0 : Int, b1 : Int, b2 : Int, b3 : Int, b4 : Int, b5 : Int) -> Mac {
  { b0, b1, b2, b3, b4, b5 }
}

// Helper function to format a byte as hex with leading zero
fn format_hex8(n : Int) -> String {
  let hex_chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']
  let high = (n >> 4) & 0xF
  let low = n & 0xF
  String::from_array([hex_chars[high], hex_chars[low]])
}

// Format MAC address to string with colon separator
pub fn format_mac(addr : Mac) -> String {
  let h0 = format_hex8(addr.b0)
  let h1 = format_hex8(addr.b1)
  let h2 = format_hex8(addr.b2)
  let h3 = format_hex8(addr.b3)
  let h4 = format_hex8(addr.b4)
  let h5 = format_hex8(addr.b5)
  
  "\{h0}:\{h1}:\{h2}:\{h3}:\{h4}:\{h5}"
}

// Check if MAC address is broadcast (ff:ff:ff:ff:ff:ff)
pub fn mac_is_broadcast(addr : Mac) -> Bool {
  addr.b0 == 0xFF && addr.b1 == 0xFF && addr.b2 == 0xFF &&
  addr.b3 == 0xFF && addr.b4 == 0xFF && addr.b5 == 0xFF
}

// Check if MAC address is multicast (first bit of first octet is 1)
pub fn mac_is_multicast(addr : Mac) -> Bool {
  (addr.b0 & 0x01) != 0
}

// Check if MAC address is unicast (first bit of first octet is 0)
pub fn mac_is_unicast(addr : Mac) -> Bool {
  (addr.b0 & 0x01) == 0
}

// Check if MAC address is locally administered (second bit of first octet is 1)
pub fn mac_is_local(addr : Mac) -> Bool {
  (addr.b0 & 0x02) != 0
}

// Check if MAC address is globally unique (second bit of first octet is 0)
pub fn mac_is_global(addr : Mac) -> Bool {
  (addr.b0 & 0x02) == 0
}

// Get the Organizationally Unique Identifier (OUI) from MAC address
pub fn mac_oui(addr : Mac) -> (Int, Int, Int) {
  (addr.b0, addr.b1, addr.b2)
}

// Convert MAC address to integer (using lower 32 bits for simplicity)
pub fn mac_to_int(addr : Mac) -> Int {
  (addr.b2 << 24) | (addr.b3 << 16) | (addr.b4 << 8) | addr.b5
}

// Convert integer to MAC address (only sets lower 4 bytes, upper 2 bytes are zero)
pub fn int_to_mac(n : Int) -> Mac {
  let b0 = 0
  let b1 = 0
  let b2 = (n >> 24) & 0xFF
  let b3 = (n >> 16) & 0xFF
  let b4 = (n >> 8) & 0xFF
  let b5 = n & 0xFF
  mac(b0, b1, b2, b3, b4, b5)
}
