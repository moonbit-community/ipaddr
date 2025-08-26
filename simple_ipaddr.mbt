// Simplified IP address library for MoonBit
// This is a basic implementation focusing on core functionality

// IPv4 address representation
///|
pub struct Ipv4 {
  a : Int
  b : Int
  c : Int
  d : Int
} derive(Eq, Compare, Show)

// IPv4 constructor

///|
pub fn ipv4(a : Int, b : Int, c : Int, d : Int) -> Ipv4 {
  { a, b, c, d }
}

// Format IPv4 address to string

///|
pub fn Ipv4::format(self : Self) -> String {
  "\{self.a}.\{self.b}.\{self.c}.\{self.d}"
}

// Simple IPv4 validation

///|
pub fn is_valid_ipv4_octet(n : Int) -> Bool {
  n >= 0 && n <= 255
}

// Check if IPv4 address is valid

///|
pub fn Ipv4::is_valid(self : Self) -> Bool {
  is_valid_ipv4_octet(self.a) &&
  is_valid_ipv4_octet(self.b) &&
  is_valid_ipv4_octet(self.c) &&
  is_valid_ipv4_octet(self.d)
}

// Convert IPv4 address to 32-bit integer (network byte order)

///|
pub fn Ipv4::to_int(self : Self) -> Int {
  (self.a << 24) | (self.b << 16) | (self.c << 8) | self.d
}

// Convert 32-bit integer to IPv4 address (network byte order)

///|
pub fn Ipv4::from_int(n : Int) -> Ipv4 {
  let a = (n >> 24) & 0xFF
  let b = (n >> 16) & 0xFF
  let c = (n >> 8) & 0xFF
  let d = n & 0xFF
  ipv4(a, b, c, d)
}

// Check if IPv4 address is private (RFC 1918)

///|
pub fn Ipv4::is_private(self : Self) -> Bool {
  // 10.0.0.0/8
  if self.a == 10 {
    return true
  }
  // 172.16.0.0/12
  if self.a == 172 && self.b >= 16 && self.b <= 31 {
    return true
  }
  // 192.168.0.0/16
  if self.a == 192 && self.b == 168 {
    return true
  }
  false
}

// Check if IPv4 address is loopback (127.0.0.0/8)

///|
pub fn Ipv4::is_loopback(self : Self) -> Bool {
  self.a == 127
}

// Check if IPv4 address is multicast (224.0.0.0/4)

///|
pub fn Ipv4::is_multicast(self : Self) -> Bool {
  self.a >= 224 && self.a <= 239
}

// Check if IPv4 address is broadcast (255.255.255.255)

///|
pub fn Ipv4::is_broadcast(self : Self) -> Bool {
  self.a == 255 && self.b == 255 && self.c == 255 && self.d == 255
}

// IPv4 CIDR prefix

///|
pub struct Ipv4Prefix {
  addr : Ipv4
  prefix_len : Int
} derive(Eq, Compare, Show)

// IPv4 prefix constructor

///|
pub fn ipv4_prefix(addr : Ipv4, prefix_len : Int) -> Ipv4Prefix {
  { addr, prefix_len }
}

// Check if an IPv4 address is in a given prefix/subnet

///|
pub fn Ipv4Prefix::contains(self : Self, addr : Ipv4) -> Bool {
  if self.prefix_len == 0 {
    return true
  }
  let prefix_int = self.addr.to_int()
  let addr_int = addr.to_int()
  let mask = (0xFFFFFFFF << (32 - self.prefix_len)) & 0xFFFFFFFF
  (prefix_int & mask) == (addr_int & mask)
}

// Get the network address for a given IPv4 prefix

///|
pub fn Ipv4Prefix::network(self : Self) -> Ipv4 {
  if self.prefix_len == 0 {
    return ipv4(0, 0, 0, 0)
  }
  let addr_int = self.addr.to_int()
  let mask = (0xFFFFFFFF << (32 - self.prefix_len)) & 0xFFFFFFFF
  let network_int = addr_int & mask
  Ipv4::from_int(network_int)
}

// Get the broadcast address for a given IPv4 prefix

///|
pub fn Ipv4Prefix::broadcast(self : Self) -> Ipv4 {
  if self.prefix_len == 0 {
    return ipv4(255, 255, 255, 255)
  }
  let addr_int = self.addr.to_int()
  let mask = (0xFFFFFFFF << (32 - self.prefix_len)) & 0xFFFFFFFF
  let broadcast_int = addr_int | (mask.lnot() & 0xFFFFFFFF)
  Ipv4::from_int(broadcast_int)
}

// MAC address (6 bytes)

///|
pub struct Mac {
  b0 : Int
  b1 : Int
  b2 : Int
  b3 : Int
  b4 : Int
  b5 : Int
} derive(Eq, Compare, Show)

// MAC constructor

///|
pub fn mac(b0 : Int, b1 : Int, b2 : Int, b3 : Int, b4 : Int, b5 : Int) -> Mac {
  { b0, b1, b2, b3, b4, b5 }
}

// Helper function to format a byte as hex with leading zero

///|
fn format_hex8(n : Int) -> String {
  let hex_chars = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
  ]
  let high = (n >> 4) & 0xF
  let low = n & 0xF
  String::from_array([hex_chars[high], hex_chars[low]])
}

// Format MAC address to string with colon separator

///|
pub fn Mac::format(self : Self) -> String {
  let h0 = format_hex8(self.b0)
  let h1 = format_hex8(self.b1)
  let h2 = format_hex8(self.b2)
  let h3 = format_hex8(self.b3)
  let h4 = format_hex8(self.b4)
  let h5 = format_hex8(self.b5)
  "\{h0}:\{h1}:\{h2}:\{h3}:\{h4}:\{h5}"
}

// Check if MAC address is broadcast (ff:ff:ff:ff:ff:ff)

///|
pub fn Mac::is_broadcast(self : Self) -> Bool {
  self.b0 == 0xFF &&
  self.b1 == 0xFF &&
  self.b2 == 0xFF &&
  self.b3 == 0xFF &&
  self.b4 == 0xFF &&
  self.b5 == 0xFF
}

// Check if MAC address is multicast (first bit of first octet is 1)

///|
pub fn Mac::is_multicast(self : Self) -> Bool {
  (self.b0 & 0x01) != 0
}

// Check if MAC address is unicast (first bit of first octet is 0)

///|
pub fn Mac::is_unicast(self : Self) -> Bool {
  (self.b0 & 0x01) == 0
}

// Check if MAC address is locally administered (second bit of first octet is 1)

///|
pub fn Mac::is_local(self : Self) -> Bool {
  (self.b0 & 0x02) != 0
}

// Check if MAC address is globally unique (second bit of first octet is 0)

///|
pub fn Mac::is_global(self : Self) -> Bool {
  (self.b0 & 0x02) == 0
}

// Get the Organizationally Unique Identifier (OUI) from MAC address

///|
pub fn Mac::oui(self : Self) -> (Int, Int, Int) {
  (self.b0, self.b1, self.b2)
}

// Convert MAC address to integer (using lower 32 bits for simplicity)

///|
pub fn Mac::to_int(self : Self) -> Int {
  (self.b2 << 24) | (self.b3 << 16) | (self.b4 << 8) | self.b5
}

// Convert integer to MAC address (only sets lower 4 bytes, upper 2 bytes are zero)

///|
pub fn Mac::from_int(n : Int) -> Mac {
  let b0 = 0
  let b1 = 0
  let b2 = (n >> 24) & 0xFF
  let b3 = (n >> 16) & 0xFF
  let b4 = (n >> 8) & 0xFF
  let b5 = n & 0xFF
  mac(b0, b1, b2, b3, b4, b5)
}
