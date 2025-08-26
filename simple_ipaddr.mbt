// Simplified IP address library for MoonBit
// This is a basic implementation focusing on core functionality

// IPv4 address representation

///|
pub struct Ipv4 {
  a : Byte
  b : Byte
  c : Byte
  d : Byte
} derive(Eq, Compare, Show)

///|
/// Creates a new IPv4 address from four octets.
///
/// # Parameters
/// - `a`: First octet (0-255)
/// - `b`: Second octet (0-255) 
/// - `c`: Third octet (0-255)
/// - `d`: Fourth octet (0-255)
///
/// # Examples
/// ```moonbit
/// let _ = @ipaddr.ipv4(127, 0, 0, 1)
/// let _ = @ipaddr.ipv4(192, 168, 1, 100)
/// let _ = @ipaddr.ipv4(8, 8, 8, 8)
/// ```
///
/// # Note
/// This function does not validate that the octets are in the valid range (0-255).
/// Use `Ipv4::is_valid()` to check if the resulting address is valid.
///
pub fn ipv4(a : Byte, b : Byte, c : Byte, d : Byte) -> Ipv4 {
  { a, b, c, d }
}

///|
/// Formats the IPv4 address as a dotted decimal string.
///
/// # Returns
/// A string representation in the format "a.b.c.d"
///
/// # Examples
/// ```moonbit
/// let addr = @ipaddr.ipv4(192, 168, 1, 1)
/// let _ = addr.format() // "192.168.1.1"
/// 
/// let localhost = @ipaddr.ipv4(127, 0, 0, 1)
/// let _ = localhost.format() // "127.0.0.1"
/// ```
///
pub fn Ipv4::format(self : Self) -> String {
  "\{self.a.to_int()}.\{self.b.to_int()}.\{self.c.to_int()}.\{self.d.to_int()}"
}

///|
/// Checks if an integer is a valid IPv4 octet (0-255).
///
/// # Parameters
/// - `n`: The integer to validate
///
/// # Returns
/// `true` if the integer is in the range [0, 255], `false` otherwise
///
/// # Examples
/// ```moonbit
/// let _ = @ipaddr.is_valid_ipv4_octet(192) // true
/// // @ipaddr.is_valid_ipv4_octet(256) returns false (out of range)
/// let _ = @ipaddr.is_valid_ipv4_octet(0) // true
/// // @ipaddr.is_valid_ipv4_octet(-1) returns false (out of range)
/// ```
///
pub fn is_valid_ipv4_octet(n : Byte) -> Bool {
  n >= 0 && n <= 255
}

/// Checks if all octets of the IPv4 address are valid (0-255).
///
/// # Returns
/// `true` if all octets are in the valid range [0, 255], `false` otherwise
///
/// # Examples
/// ```moonbit
/// let valid_addr = @ipaddr.ipv4(192, 168, 1, 1)
/// let _ = valid = valid_addr.is_valid() // true
/// 
/// let invalid_addr = @ipaddr.ipv4(256, 168, 1, 1)
/// let _ = invalid = invalid_addr.is_valid() // false
/// 
/// let edge_addr = @ipaddr.ipv4(0, 0, 0, 0)
/// let _ = edge_valid = edge_addr.is_valid() // true
/// ```

///|
pub fn Ipv4::is_valid(self : Self) -> Bool {
  is_valid_ipv4_octet(self.a) &&
  is_valid_ipv4_octet(self.b) &&
  is_valid_ipv4_octet(self.c) &&
  is_valid_ipv4_octet(self.d)
}

///|
/// Converts the IPv4 address to a 32-bit integer in network byte order.
///
/// The conversion follows the standard network byte order (big-endian):
/// - First octet becomes the most significant byte
/// - Fourth octet becomes the least significant byte
///
/// # Returns
/// A 32-bit integer representation of the IPv4 address
///
/// # Examples
/// ```moonbit
/// let addr = @ipaddr.ipv4(192, 168, 1, 1)
/// let _ = addr.to_int() // 3232235777
/// 
/// let localhost = @ipaddr.ipv4(127, 0, 0, 1)
/// let _ = localhost.to_int() // 2130706433
/// 
/// let zero = @ipaddr.ipv4(0, 0, 0, 0)
/// let _ = zero.to_int() // 0
/// ```
///
pub fn Ipv4::to_int(self : Self) -> Int {
  (self.a.to_int() << 24) | (self.b.to_int() << 16) | (self.c.to_int() << 8) | self.d.to_int()
}

///|
/// Creates an IPv4 address from a 32-bit integer in network byte order.
///
/// The conversion follows the standard network byte order (big-endian):
/// - Most significant byte becomes the first octet
/// - Least significant byte becomes the fourth octet
///
/// # Parameters
/// - `n`: A 32-bit integer representing the IPv4 address
///
/// # Returns
/// An IPv4 address constructed from the integer
///
/// # Examples
/// ```moonbit
/// let addr = @ipaddr.Ipv4::from_int(0x7F000001) // 127.0.0.1
/// let _ = addr.format() // "127.0.0.1"
/// 
/// let localhost = @ipaddr.Ipv4::from_int(0x7F000001) // 127.0.0.1
/// let _ = localhost.format() // "127.0.0.1"
/// 
/// let _ = @ipaddr.Ipv4::from_int(0) // 0.0.0.0
/// ```
///
pub fn Ipv4::from_int(n : Int) -> Ipv4 {
  let a = ((n >> 24) & 0xFF).to_byte()
  let b = ((n >> 16) & 0xFF).to_byte()
  let c = ((n >> 8) & 0xFF).to_byte()
  let d = (n & 0xFF).to_byte()
  ipv4(a, b, c, d)
}

///|
/// Checks if the IPv4 address is a private address as defined by RFC 1918.
///
/// Private address ranges are:
/// - 10.0.0.0/8 (10.0.0.0 to 10.255.255.255)
/// - 172.16.0.0/12 (172.16.0.0 to 172.31.255.255)
/// - 192.168.0.0/16 (192.168.0.0 to 192.168.255.255)
///
/// # Returns
/// `true` if the address is in a private range, `false` otherwise
///
/// # Examples
/// ```moonbit
/// let private1 = @ipaddr.ipv4(10, 0, 0, 1)
/// let _ = private1.is_private() // true
/// 
/// let private2 = @ipaddr.ipv4(172, 16, 0, 1)
/// let _ = private2.is_private() // true
/// 
/// let private3 = @ipaddr.ipv4(192, 168, 1, 1)
/// let _ = private3.is_private() // true
/// 
/// let public_addr = @ipaddr.ipv4(8, 8, 8, 8)
/// let _ = public_addr.is_private() // false
/// ```
///
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

///|
/// Checks if the IPv4 address is a loopback address.
///
/// Loopback addresses are in the range 127.0.0.0/8 (127.0.0.0 to 127.255.255.255).
/// These addresses are used to refer to the local host.
///
/// # Returns
/// `true` if the address is a loopback address, `false` otherwise
///
/// # Examples
/// ```moonbit
/// let localhost = @ipaddr.ipv4(127, 0, 0, 1)
/// let _ = localhost.is_loopback() // true
/// 
/// let loopback_variant = @ipaddr.ipv4(127, 1, 2, 3)
/// let _ = loopback_variant.is_loopback() // true
/// 
/// let not_loopback = @ipaddr.ipv4(192, 168, 1, 1)
/// let _ = not_loopback.is_loopback() // false
/// ```
///
pub fn Ipv4::is_loopback(self : Self) -> Bool {
  self.a == 127
}

///|
/// Checks if the IPv4 address is a multicast address.
///
/// Multicast addresses are in the range 224.0.0.0/4 (224.0.0.0 to 239.255.255.255).
/// These addresses are used for multicast communication where data is sent to
/// multiple recipients simultaneously.
///
/// # Returns
/// `true` if the address is a multicast address, `false` otherwise
///
/// # Examples
/// ```moonbit
/// let multicast1 = @ipaddr.ipv4(224, 0, 0, 1)
/// let _ = multicast1.is_multicast() // true
/// 
/// let multicast2 = @ipaddr.ipv4(239, 255, 255, 255)
/// let _ = multicast2.is_multicast() // true
/// 
/// let unicast = @ipaddr.ipv4(192, 168, 1, 1)
/// let _ = unicast.is_multicast() // false
/// ```
///
pub fn Ipv4::is_multicast(self : Self) -> Bool {
  self.a >= 224 && self.a <= 239
}

///|
/// Checks if the IPv4 address is the limited broadcast address.
///
/// The limited broadcast address is 255.255.255.255, which is used to send
/// packets to all hosts on the local network segment.
///
/// # Returns
/// `true` if the address is 255.255.255.255, `false` otherwise
///
/// # Examples
/// ```moonbit
/// let broadcast = @ipaddr.ipv4(255, 255, 255, 255)
/// let _ = broadcast.is_broadcast() // true
/// 
/// let not_broadcast = @ipaddr.ipv4(192, 168, 1, 255)
/// let _ = not_broadcast.is_broadcast() // false
/// 
/// let almost_broadcast = @ipaddr.ipv4(255, 255, 255, 254)
/// let _ = almost_broadcast.is_broadcast() // false
/// ```
///
pub fn Ipv4::is_broadcast(self : Self) -> Bool {
  self.a == 255 && self.b == 255 && self.c == 255 && self.d == 255
}

///|
///  IPv4 CIDR prefix
///
pub struct Ipv4Prefix {
  addr : Ipv4
  prefix_len : Int
} derive(Eq, Compare, Show)

///|
/// Creates a new IPv4 CIDR prefix from an address and prefix length.
///
/// A CIDR prefix represents a network subnet using an IPv4 address and a prefix length.
/// The prefix length indicates how many bits from the left are used for the network portion.
///
/// # Parameters
/// - `addr`: The IPv4 address (typically the network address)
/// - `prefix_len`: The prefix length in bits (0-32)
///
/// # Returns
/// An Ipv4Prefix representing the network subnet
///
/// # Examples
/// ```moonbit
/// // Create a /24 subnet (255.255.255.0 netmask)
/// let _ = @ipaddr.ipv4_prefix(@ipaddr.ipv4(192, 168, 1, 0), 24)
/// 
/// // Create a /16 subnet (255.255.0.0 netmask)
/// let _ = @ipaddr.ipv4_prefix(@ipaddr.ipv4(10, 0, 0, 0), 16)
/// 
/// // Create a /32 host route (255.255.255.255 netmask)
/// let _ = @ipaddr.ipv4_prefix(@ipaddr.ipv4(8, 8, 8, 8), 32)
/// ```
///
pub fn ipv4_prefix(addr : Ipv4, prefix_len : Int) -> Ipv4Prefix {
  { addr, prefix_len }
}

///|
/// Checks if an IPv4 address is contained within this CIDR prefix/subnet.
///
/// This method determines if the given address belongs to the network defined
/// by this prefix by comparing the network portions of both addresses.
///
/// # Parameters
/// - `addr`: The IPv4 address to check
///
/// # Returns
/// `true` if the address is within the subnet, `false` otherwise
///
/// # Examples
/// ```moonbit
/// let subnet = @ipaddr.ipv4_prefix(@ipaddr.ipv4(192, 168, 1, 0), 24)
/// 
/// let addr1 = @ipaddr.ipv4(192, 168, 1, 1)
/// let _ = subnet.contains(addr1) // true
/// 
/// let addr2 = @ipaddr.ipv4(192, 168, 1, 255)
/// let _ = subnet.contains(addr2) // true
/// 
/// let addr3 = @ipaddr.ipv4(192, 168, 2, 1)
/// let _ = subnet.contains(addr3) // false
/// 
/// // Special case: /0 contains all addresses
/// let all_networks = @ipaddr.ipv4_prefix(@ipaddr.ipv4(0, 0, 0, 0), 0)
/// let _ = all_networks.contains(@ipaddr.ipv4(8, 8, 8, 8)) // true
/// ```
///
pub fn Ipv4Prefix::contains(self : Self, addr : Ipv4) -> Bool {
  if self.prefix_len == 0 {
    return true
  }
  let prefix_int = self.addr.to_int()
  let addr_int = addr.to_int()
  let mask = (0xFFFFFFFF << (32 - self.prefix_len)) & 0xFFFFFFFF
  (prefix_int & mask) == (addr_int & mask)
}

///|
/// Gets the network address for this IPv4 prefix.
///
/// The network address is the first address in the subnet, obtained by
/// setting all host bits to zero. This is also known as the subnet address.
///
/// # Returns
/// The network address as an IPv4 address
///
/// # Examples
/// ```moonbit
/// let prefix = @ipaddr.ipv4_prefix(@ipaddr.ipv4(192, 168, 1, 100), 24)
/// let network = prefix.network() // 192.168.1.0
/// let _ = network.format() // "192.168.1.0"
/// 
/// let prefix16 = @ipaddr.ipv4_prefix(@ipaddr.ipv4(10, 5, 10, 20), 16)
/// let _ = prefix16.network() // 10.5.0.0
/// 
/// // Special case: /0 network is 0.0.0.0
/// let default_route = @ipaddr.ipv4_prefix(@ipaddr.ipv4(8, 8, 8, 8), 0)
/// let _ = default_route.network() // 0.0.0.0
/// ```
///
pub fn Ipv4Prefix::network(self : Self) -> Ipv4 {
  if self.prefix_len == 0 {
    return ipv4(0, 0, 0, 0)
  }
  let addr_int = self.addr.to_int()
  let mask = (0xFFFFFFFF << (32 - self.prefix_len)) & 0xFFFFFFFF
  let network_int = addr_int & mask
  Ipv4::from_int(network_int)
}

///|
/// Gets the broadcast address for this IPv4 prefix.
///
/// The broadcast address is the last address in the subnet, obtained by
/// setting all host bits to one. Packets sent to this address are delivered
/// to all hosts in the subnet.
///
/// # Returns
/// The broadcast address as an IPv4 address
///
/// # Examples
/// ```moonbit
/// let prefix = @ipaddr.ipv4_prefix(@ipaddr.ipv4(192, 168, 1, 0), 24)
/// let broadcast = prefix.broadcast() // 192.168.1.255
/// let _ = broadcast.format() // "192.168.1.255"
/// 
/// let prefix16 = @ipaddr.ipv4_prefix(@ipaddr.ipv4(10, 5, 0, 0), 16)
/// let _ = prefix16.broadcast() // 10.5.255.255
/// 
/// // Special case: /0 broadcast is 255.255.255.255
/// let default_route = @ipaddr.ipv4_prefix(@ipaddr.ipv4(0, 0, 0, 0), 0)
/// let _ = default_route.broadcast() // 255.255.255.255
/// ```
///
pub fn Ipv4Prefix::broadcast(self : Self) -> Ipv4 {
  if self.prefix_len == 0 {
    return ipv4(255, 255, 255, 255)
  }
  let addr_int = self.addr.to_int()
  let mask = (0xFFFFFFFF << (32 - self.prefix_len)) & 0xFFFFFFFF
  let broadcast_int = addr_int | (mask.lnot() & 0xFFFFFFFF)
  Ipv4::from_int(broadcast_int)
}

///|
///  MAC address (6 bytes)
///
pub struct Mac {
  b0 : Int
  b1 : Int
  b2 : Int
  b3 : Int
  b4 : Int
  b5 : Int
} derive(Eq, Compare, Show)

///|
/// Creates a new MAC address from six bytes.
///
/// MAC (Media Access Control) addresses are 48-bit identifiers used to uniquely
/// identify network interfaces. They are typically displayed in hexadecimal format
/// separated by colons (e.g., "00:11:22:33:44:55").
///
/// # Parameters
/// - `b0`: First byte (most significant)
/// - `b1`: Second byte
/// - `b2`: Third byte
/// - `b3`: Fourth byte
/// - `b4`: Fifth byte
/// - `b5`: Sixth byte (least significant)
///
/// # Examples
/// ```moonbit
/// // Create a typical MAC address
/// let _ = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// 
/// // Create a broadcast MAC address
/// let _ = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
/// 
/// // Create a multicast MAC address (first bit of first byte is 1)
/// let _ = @ipaddr.mac(0x01, 0x00, 0x5E, 0x00, 0x00, 0x01)
/// ```
///
pub fn mac(b0 : Int, b1 : Int, b2 : Int, b3 : Int, b4 : Int, b5 : Int) -> Mac {
  { b0, b1, b2, b3, b4, b5 }
}

///|
/// Helper function to format a byte as a two-digit lowercase hexadecimal string.
///
/// This internal utility function converts an integer (0-255) to a two-character
/// hexadecimal string with leading zeros if necessary. Used internally by MAC
/// address formatting.
///
/// # Parameters
/// - `n`: An integer in the range 0-255
///
/// # Returns
/// A two-character lowercase hexadecimal string
///
/// # Examples
/// ```moonbit
/// // Internal function, typically not called directly
/// // Internal function examples: "00", "0f", "ff", "ab"
/// ```
///
fn format_hex8(n : Int) -> String {
  let hex_chars = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
  ]
  let high = (n >> 4) & 0xF
  let low = n & 0xF
  String::from_array([hex_chars[high], hex_chars[low]])
}

///|
/// Formats the MAC address as a colon-separated hexadecimal string.
///
/// The format follows the standard MAC address notation with lowercase
/// hexadecimal digits separated by colons (e.g., "00:11:22:33:44:55").
///
/// # Returns
/// A string representation in the format "xx:xx:xx:xx:xx:xx"
///
/// # Examples
/// ```moonbit
/// let addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = addr.format() // "00:11:22:33:44:55"
/// 
/// let _ = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
/// let broadcast = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
/// let _ = broadcast.format() // "ff:ff:ff:ff:ff:ff"
/// 
/// let zero_mac = @ipaddr.mac(0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
/// let _ = zero_mac.format() // "00:00:00:00:00:00"
/// ```
///
pub fn Mac::format(self : Self) -> String {
  let h0 = format_hex8(self.b0)
  let h1 = format_hex8(self.b1)
  let h2 = format_hex8(self.b2)
  let h3 = format_hex8(self.b3)
  let h4 = format_hex8(self.b4)
  let h5 = format_hex8(self.b5)
  "\{h0}:\{h1}:\{h2}:\{h3}:\{h4}:\{h5}"
}

///|
/// Checks if the MAC address is the broadcast address.
///
/// The broadcast MAC address is ff:ff:ff:ff:ff:ff, which is used to send
/// frames to all devices on the local network segment.
///
/// # Returns
/// `true` if the address is ff:ff:ff:ff:ff:ff, `false` otherwise
///
/// # Examples
/// ```moonbit
/// let broadcast = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
/// let _ = broadcast.is_broadcast() // true
/// 
/// let normal_mac = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = normal_mac.is_broadcast() // false
/// 
/// let almost_broadcast = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE)
/// let _ = almost_broadcast.is_broadcast() // false
/// ```
///
pub fn Mac::is_broadcast(self : Self) -> Bool {
  self.b0 == 0xFF &&
  self.b1 == 0xFF &&
  self.b2 == 0xFF &&
  self.b3 == 0xFF &&
  self.b4 == 0xFF &&
  self.b5 == 0xFF
}

///|
/// Checks if the MAC address is a multicast address.
///
/// A MAC address is multicast if the least significant bit of the first octet
/// is set to 1. Multicast addresses are used to send frames to a group of
/// devices rather than a single device.
///
/// # Returns
/// `true` if the address is multicast, `false` otherwise
///
/// # Examples
/// ```moonbit
/// // Multicast address (first bit of 0x01 is 1)
/// let _ = @ipaddr.mac(0x01, 0x00, 0x5E, 0x00, 0x00, 0x01)
/// let multicast = @ipaddr.mac(0x01, 0x00, 0x5E, 0x00, 0x00, 0x01)
/// let _ = multicast.is_multicast() // true
/// 
/// // Broadcast is also multicast
/// let _ = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
/// let broadcast = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
/// let _ = broadcast.is_multicast() // true
/// 
/// // Unicast address (first bit of 0x00 is 0)
/// let unicast = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = unicast.is_multicast() // false
/// ```
///
pub fn Mac::is_multicast(self : Self) -> Bool {
  (self.b0 & 0x01) != 0
}

/// Checks if the MAC address is a unicast address.
///
/// A MAC address is unicast if the least significant bit of the first octet
/// is set to 0. Unicast addresses are used to send frames to a single specific
/// device on the network.
///
/// # Returns
/// `true` if the address is unicast, `false` otherwise
///
/// # Examples
/// ```moonbit
/// // Unicast address (first bit of 0x00 is 0)
/// let unicast = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = unicast = unicast.is_unicast() // true
/// 
/// // Another unicast address (first bit of 0x02 is 0)
/// let unicast2 = @ipaddr.mac(0x02, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = also_unicast = unicast2.is_unicast() // true
/// 
/// // Multicast address (first bit of 0x01 is 1)
/// let _ = @ipaddr.mac(0x01, 0x00, 0x5E, 0x00, 0x00, 0x01)
/// let _ = not_unicast = multicast.is_unicast() // false
/// ```

///|
pub fn Mac::is_unicast(self : Self) -> Bool {
  (self.b0 & 0x01) == 0
}

///|
/// Checks if the MAC address is locally administered.
///
/// A MAC address is locally administered if the second least significant bit
/// of the first octet is set to 1. Locally administered addresses are assigned
/// by the local network administrator rather than by the manufacturer.
///
/// # Returns
/// `true` if the address is locally administered, `false` otherwise
///
/// # Examples
/// ```moonbit
/// // Locally administered address (second bit of 0x02 is 1)
/// let local_mac = @ipaddr.mac(0x02, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = local_mac.is_local() // true
/// 
/// // Another locally administered address (0x03 = 0b00000011)
/// let local_mac2 = @ipaddr.mac(0x03, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = local_mac2.is_local() // true
/// 
/// // Globally unique address (second bit of 0x00 is 0)
/// let global_mac = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = global_mac.is_local() // false
/// ```
///
pub fn Mac::is_local(self : Self) -> Bool {
  (self.b0 & 0x02) != 0
}

///|
/// Checks if the MAC address is globally unique.
///
/// A MAC address is globally unique if the second least significant bit
/// of the first octet is set to 0. Globally unique addresses are assigned
/// by the manufacturer and should be unique worldwide.
///
/// # Returns
/// `true` if the address is globally unique, `false` otherwise
///
/// # Examples
/// ```moonbit
/// // Globally unique address (second bit of 0x00 is 0)
/// let global_mac = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = global_mac.is_global() // true
/// 
/// // Another globally unique address (0x01 = 0b00000001, second bit is 0)
/// let global_mac2 = @ipaddr.mac(0x01, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = global_mac2.is_global() // true
/// 
/// // Locally administered address (second bit of 0x02 is 1)
/// let local_mac = @ipaddr.mac(0x02, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = local_mac.is_global() // false
/// ```
///
pub fn Mac::is_global(self : Self) -> Bool {
  (self.b0 & 0x02) == 0
}

///|
/// Gets the Organizationally Unique Identifier (OUI) from the MAC address.
///
/// The OUI is the first three bytes of a MAC address, assigned by the IEEE
/// to identify the manufacturer or organization. It uniquely identifies the
/// vendor of the network interface.
///
/// # Returns
/// A tuple containing the three OUI bytes (b0, b1, b2)
///
/// # Examples
/// ```moonbit
/// let addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let (_, _, _) = addr.oui() // (0x00, 0x11, 0x22)
/// 
/// // Apple's OUI is 00:17:F2
/// let apple_mac = @ipaddr.mac(0x00, 0x17, 0xF2, 0x12, 0x34, 0x56)
/// let (_, _, _) = apple_mac.oui() // (0x00, 0x17, 0xF2)
/// 
/// // Intel's OUI is 00:15:17
/// let intel_mac = @ipaddr.mac(0x00, 0x15, 0x17, 0xAB, 0xCD, 0xEF)
/// let (_, _, _) = intel_mac.oui() // (0x00, 0x15, 0x17)
/// ```
///
pub fn Mac::oui(self : Self) -> (Int, Int, Int) {
  (self.b0, self.b1, self.b2)
}

///|
/// Converts the MAC address to a 32-bit integer using the lower 4 bytes.
///
/// This conversion uses only the last 4 bytes (b2, b3, b4, b5) of the MAC address
/// for simplicity, as full 48-bit integers are not commonly used. The first two
/// bytes (b0, b1) are ignored in this conversion.
///
/// # Returns
/// A 32-bit integer representation of the lower 4 bytes
///
/// # Examples
/// ```moonbit
/// let addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
/// let _ = addr.to_int() // Uses bytes 0x22, 0x33, 0x44, 0x55
/// 
/// let simple_mac = @ipaddr.mac(0x00, 0x00, 0x00, 0x00, 0x00, 0x01)
/// let _ = simple_mac.to_int() // 1
/// 
/// let zero_mac = @ipaddr.mac(0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00)
/// let _ = zero_mac.to_int() // 0 (ignores first two 0xFF bytes)
/// ```
///
pub fn Mac::to_int(self : Self) -> Int {
  (self.b2 << 24) | (self.b3 << 16) | (self.b4 << 8) | self.b5
}

///|
/// Creates a MAC address from a 32-bit integer, setting only the lower 4 bytes.
///
/// This conversion creates a MAC address where the first two bytes (b0, b1) are
/// set to zero, and the remaining four bytes are derived from the 32-bit integer.
/// This is useful for creating MAC addresses from simple integer identifiers.
///
/// # Parameters
/// - `n`: A 32-bit integer to convert to MAC address
///
/// # Returns
/// A MAC address with the first two bytes as 0x00 and the last four bytes from the integer
///
/// # Examples
/// ```moonbit
/// let mac_from_1 = @ipaddr.Mac::from_int(1) // 00:00:00:00:00:01
/// let _ = mac_from_1.format() // "00:00:00:00:00:01"
/// 
/// let mac_from_large = @ipaddr.Mac::from_int(0x12345678) // 00:00:12:34:56:78
/// let _ = mac_from_large.format() // "00:00:12:34:56:78"
/// 
/// // Round trip conversion
/// let original = @ipaddr.mac(0x00, 0x00, 0x22, 0x33, 0x44, 0x55)
/// let int_val = original.to_int()
/// let _ = @ipaddr.Mac::from_int(int_val) // Same as original
/// ```
///
pub fn Mac::from_int(n : Int) -> Mac {
  let b0 = 0
  let b1 = 0
  let b2 = (n >> 24) & 0xFF
  let b3 = (n >> 16) & 0xFF
  let b4 = (n >> 8) & 0xFF
  let b5 = n & 0xFF
  mac(b0, b1, b2, b3, b4, b5)
}
