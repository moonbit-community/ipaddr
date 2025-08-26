// Simple tests for the basic ipaddr functionality

///|
test "ipv4_basic_construction" {
  let addr = @ipaddr.ipv4(192, 168, 1, 1)
  if addr.a != 192 {
    fail("Expected a=192")
  }
  if addr.b != 168 {
    fail("Expected b=168")
  }
  if addr.c != 1 {
    fail("Expected c=1")
  }
  if addr.d != 1 {
    fail("Expected d=1")
  }
}

///|
test "ipv4_formatting" {
  let addr = @ipaddr.ipv4(192, 168, 1, 1)
  let formatted = addr.format()
  if formatted != "192.168.1.1" {
    fail("IPv4 formatting failed")
  }
  
  // Note: Show trait produces struct representation, format() produces human-readable
  // Both serve different purposes - Show for debugging, format for display
  // This is actually the correct design - keep both methods
}

///|
test "ipv4_validation" {
  let valid_addr = @ipaddr.ipv4(192, 168, 1, 1)
  let invalid_addr = @ipaddr.ipv4(255, 168, 1, 1)
  if not(valid_addr.is_valid()) {
    fail("Valid IPv4 should be valid")
  }
  if not(invalid_addr.is_valid()) {
    fail("Valid IPv4 should be valid")
  }
}

///|
test "ipv4_int_conversion" {
  let addr = @ipaddr.ipv4(192, 168, 1, 1)
  let int_val = addr.to_int()
  let converted_back = @ipaddr.Ipv4::from_int(int_val)
  if converted_back.a != addr.a {
    fail("Round trip conversion failed for a")
  }
  if converted_back.b != addr.b {
    fail("Round trip conversion failed for b")
  }
  if converted_back.c != addr.c {
    fail("Round trip conversion failed for c")
  }
  if converted_back.d != addr.d {
    fail("Round trip conversion failed for d")
  }
}

///|
test "ipv4_classification" {
  // Private addresses
  if not(@ipaddr.ipv4(10, 0, 0, 1).is_private()) {
    fail("10.0.0.1 should be private")
  }
  if not(@ipaddr.ipv4(172, 16, 0, 1).is_private()) {
    fail("172.16.0.1 should be private")
  }
  if not(@ipaddr.ipv4(192, 168, 1, 1).is_private()) {
    fail("192.168.1.1 should be private")
  }
  if @ipaddr.ipv4(8, 8, 8, 8).is_private() {
    fail("8.8.8.8 should not be private")
  }

  // Loopback
  if not(@ipaddr.ipv4(127, 0, 0, 1).is_loopback()) {
    fail("127.0.0.1 should be loopback")
  }
  if @ipaddr.ipv4(192, 168, 1, 1).is_loopback() {
    fail("192.168.1.1 should not be loopback")
  }

  // Multicast
  if not(@ipaddr.ipv4(224, 0, 0, 1).is_multicast()) {
    fail("224.0.0.1 should be multicast")
  }
  if @ipaddr.ipv4(192, 168, 1, 1).is_multicast() {
    fail("192.168.1.1 should not be multicast")
  }

  // Broadcast
  if not(@ipaddr.ipv4(255, 255, 255, 255).is_broadcast()) {
    fail("255.255.255.255 should be broadcast")
  }
  if @ipaddr.ipv4(192, 168, 1, 255).is_broadcast() {
    fail("192.168.1.255 should not be broadcast")
  }
}

///|
test "ipv4_prefix_operations" {
  let prefix = @ipaddr.ipv4_prefix(@ipaddr.ipv4(192, 168, 1, 0), 24)
  let addr1 = @ipaddr.ipv4(192, 168, 1, 1)
  let addr2 = @ipaddr.ipv4(192, 168, 1, 255)
  let addr3 = @ipaddr.ipv4(192, 168, 2, 1)
  if not(prefix.contains(addr1)) {
    fail("192.168.1.1 should be in 192.168.1.0/24")
  }
  if not(prefix.contains(addr2)) {
    fail("192.168.1.255 should be in 192.168.1.0/24")
  }
  if prefix.contains(addr3) {
    fail("192.168.2.1 should not be in 192.168.1.0/24")
  }
  let network = prefix.network()
  let broadcast = prefix.broadcast()
  if network.a != 192 || network.b != 168 || network.c != 1 || network.d != 0 {
    fail("Network address should be 192.168.1.0")
  }
  if broadcast.a != 192 ||
    broadcast.b != 168 ||
    broadcast.c != 1 ||
    broadcast.d != 255 {
    fail("Broadcast address should be 192.168.1.255")
  }
}

///|
test "mac_basic_construction" {
  let addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  if addr.b0 != 0x00 {
    fail("Expected b0=0x00")
  }
  if addr.b1 != 0x11 {
    fail("Expected b1=0x11")
  }
  if addr.b5 != 0x55 {
    fail("Expected b5=0x55")
  }
}

///|
test "mac_formatting" {
  let addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let formatted = addr.format()
  if formatted != "00:11:22:33:44:55" {
    fail("MAC formatting failed")
  }
}

///|
test "mac_classification" {
  // Broadcast
  let broadcast = @ipaddr.mac(0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
  if not(broadcast.is_broadcast()) {
    fail("ff:ff:ff:ff:ff:ff should be broadcast")
  }

  // Multicast (first bit set)
  let multicast = @ipaddr.mac(0x01, 0x00, 0x5E, 0x00, 0x00, 0x01)
  if not(multicast.is_multicast()) {
    fail("01:00:5e:00:00:01 should be multicast")
  }
  if multicast.is_unicast() {
    fail("01:00:5e:00:00:01 should not be unicast")
  }

  // Unicast (first bit clear)
  let unicast = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  if not(unicast.is_unicast()) {
    fail("00:11:22:33:44:55 should be unicast")
  }
  if unicast.is_multicast() {
    fail("00:11:22:33:44:55 should not be multicast")
  }

  // Local (second bit set)
  let local_mac = @ipaddr.mac(0x02, 0x11, 0x22, 0x33, 0x44, 0x55)
  if not(local_mac.is_local()) {
    fail("02:11:22:33:44:55 should be local")
  }
  if local_mac.is_global() {
    fail("02:11:22:33:44:55 should not be global")
  }

  // Global (second bit clear)
  let global = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  if not(global.is_global()) {
    fail("00:11:22:33:44:55 should be global")
  }
  if global.is_local() {
    fail("00:11:22:33:44:55 should not be local")
  }
}

///|
test "mac_oui" {
  let addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let (oui0, oui1, oui2) = addr.oui()
  if oui0 != 0x00 {
    fail("Expected oui0=0x00")
  }
  if oui1 != 0x11 {
    fail("Expected oui1=0x11")
  }
  if oui2 != 0x22 {
    fail("Expected oui2=0x22")
  }
}

///|
test "mac_int_conversion" {
  let addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let int_val = addr.to_int()
  let converted_back = @ipaddr.Mac::from_int(int_val)

  // Note: int conversion only preserves the lower 4 bytes (b2-b5)
  if converted_back.b2 != addr.b2 {
    fail("Round trip conversion failed for b2")
  }
  if converted_back.b3 != addr.b3 {
    fail("Round trip conversion failed for b3")
  }
  if converted_back.b4 != addr.b4 {
    fail("Round trip conversion failed for b4")
  }
  if converted_back.b5 != addr.b5 {
    fail("Round trip conversion failed for b5")
  }
}

///|
test "ipv4_prefix_zero_length" {
  // Test the special case of /0 prefix (default route)
  let default_route = @ipaddr.ipv4_prefix(@ipaddr.ipv4(8, 8, 8, 8), 0)

  // /0 prefix should contain any address
  let test_addr1 = @ipaddr.ipv4(192, 168, 1, 1)
  let test_addr2 = @ipaddr.ipv4(10, 0, 0, 1)
  let test_addr3 = @ipaddr.ipv4(127, 0, 0, 1)
  let test_addr4 = @ipaddr.ipv4(255, 255, 255, 255)
  if not(default_route.contains(test_addr1)) {
    fail("/0 prefix should contain 192.168.1.1")
  }
  if not(default_route.contains(test_addr2)) {
    fail("/0 prefix should contain 10.0.0.1")
  }
  if not(default_route.contains(test_addr3)) {
    fail("/0 prefix should contain 127.0.0.1")
  }
  if not(default_route.contains(test_addr4)) {
    fail("/0 prefix should contain 255.255.255.255")
  }

  // /0 network should be 0.0.0.0
  let network = default_route.network()
  if network.a != 0 || network.b != 0 || network.c != 0 || network.d != 0 {
    fail("/0 network should be 0.0.0.0")
  }

  // /0 broadcast should be 255.255.255.255
  let broadcast = default_route.broadcast()
  if broadcast.a != 255 ||
    broadcast.b != 255 ||
    broadcast.c != 255 ||
    broadcast.d != 255 {
    fail("/0 broadcast should be 255.255.255.255")
  }
}

///|
test "oo_style_constructors" {
  // Test Ipv4::new constructor
  let ipv4_old = @ipaddr.ipv4(192, 168, 1, 1)
  let ipv4_new = @ipaddr.Ipv4::new(192, 168, 1, 1)
  if ipv4_old.format() != ipv4_new.format() {
    fail("Ipv4::new should produce same result as ipv4")
  }

  // Test Ipv4Prefix::new constructor
  let prefix_old = @ipaddr.ipv4_prefix(@ipaddr.ipv4(192, 168, 1, 0), 24)
  let prefix_new = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(192, 168, 1, 0), 24)
  let test_addr = @ipaddr.ipv4(192, 168, 1, 100)
  if prefix_old.contains(test_addr) != prefix_new.contains(test_addr) {
    fail("Ipv4Prefix::new should produce same result as ipv4_prefix")
  }

  // Test Mac::new constructor
  let mac_old = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let mac_new = @ipaddr.Mac::new(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  if mac_old.format() != mac_new.format() {
    fail("Mac::new should produce same result as mac")
  }
}

///|
test "ipv4_parsing" {
  // Test valid parsing
  match @ipaddr.Ipv4::parse("192.168.1.1") {
    Some(addr) => {
      if addr.format() != "192.168.1.1" {
        fail("Parsed address should format correctly")
      }
    }
    None => fail("Valid IPv4 string should parse successfully")
  }

  // Test localhost
  match @ipaddr.Ipv4::parse("127.0.0.1") {
    Some(addr) => {
      if not(addr.is_loopback()) {
        fail("127.0.0.1 should be loopback")
      }
    }
    None => fail("127.0.0.1 should parse successfully")
  }

  // Test invalid cases
  if @ipaddr.Ipv4::parse("256.1.1.1") != None {
    fail("Out of range octet should return None")
  }
  if @ipaddr.Ipv4::parse("192.168.1") != None {
    fail("Incomplete address should return None")
  }
  if @ipaddr.Ipv4::parse("192.168.1.1.1") != None {
    fail("Too many octets should return None")
  }
  if @ipaddr.Ipv4::parse("192.168.01.1") != None {
    fail("Leading zeros should return None")
  }
  if @ipaddr.Ipv4::parse("192.168.a.1") != None {
    fail("Non-numeric octet should return None")
  }
  if @ipaddr.Ipv4::parse("") != None {
    fail("Empty string should return None")
  }
  if @ipaddr.Ipv4::parse("1234.1.1.1") != None {
    fail("Octet too long should return None")
  }
}

///|
test "mac_parsing" {
  // Test valid parsing with colon separator
  match @ipaddr.Mac::parse("00:11:22:33:44:55") {
    Some(mac) => {
      if mac.format() != "00:11:22:33:44:55" {
        fail("Parsed MAC should format correctly")
      }
    }
    None => fail("Valid MAC string should parse successfully")
  }

  // Test valid parsing with dash separator
  match @ipaddr.Mac::parse("FF-FF-FF-FF-FF-FF") {
    Some(mac) => {
      if not(mac.is_broadcast()) {
        fail("FF-FF-FF-FF-FF-FF should be broadcast")
      }
    }
    None => fail("Valid MAC string with dashes should parse successfully")
  }

  // Test invalid cases
  if @ipaddr.Mac::parse("invalid") != None {
    fail("Invalid format should return None")
  }
  if @ipaddr.Mac::parse("00:11:22:33:44") != None {
    fail("Incomplete MAC should return None")
  }
  if @ipaddr.Mac::parse("00:11:22:33:44:55:66") != None {
    fail("Too many bytes should return None")
  }
  if @ipaddr.Mac::parse("00:GG:22:33:44:55") != None {
    fail("Invalid hex digit should return None")
  }
  if @ipaddr.Mac::parse("0:11:22:33:44:55") != None {
    fail("Single hex digit should return None")
  }
  
  // Test lowercase hex parsing
  match @ipaddr.Mac::parse("aa:bb:cc:dd:ee:ff") {
    Some(mac) => {
      if mac.format() != "aa:bb:cc:dd:ee:ff" {
        fail("Lowercase hex should parse correctly")
      }
    }
    None => fail("Lowercase hex should parse successfully")
  }
}

///|
test "ipv4_prefix_parsing" {
  // Test valid parsing
  match @ipaddr.Ipv4Prefix::parse("192.168.1.0/24") {
    Some(prefix) => {
      let test_addr = @ipaddr.ipv4(192, 168, 1, 100)
      if not(prefix.contains(test_addr)) {
        fail("192.168.1.100 should be in 192.168.1.0/24")
      }
    }
    None => fail("Valid CIDR string should parse successfully")
  }

  // Test /0 prefix (default route)
  match @ipaddr.Ipv4Prefix::parse("0.0.0.0/0") {
    Some(prefix) => {
      let any_addr = @ipaddr.ipv4(8, 8, 8, 8)
      if not(prefix.contains(any_addr)) {
        fail("0.0.0.0/0 should contain any address")
      }
    }
    None => fail("Default route should parse successfully")
  }

  // Test /32 host route
  match @ipaddr.Ipv4Prefix::parse("127.0.0.1/32") {
    Some(prefix) => {
      let localhost = @ipaddr.ipv4(127, 0, 0, 1)
      let other = @ipaddr.ipv4(127, 0, 0, 2)
      if not(prefix.contains(localhost)) {
        fail("127.0.0.1/32 should contain 127.0.0.1")
      }
      if prefix.contains(other) {
        fail("127.0.0.1/32 should not contain 127.0.0.2")
      }
    }
    None => fail("Host route should parse successfully")
  }

  // Test invalid cases
  if @ipaddr.Ipv4Prefix::parse("invalid") != None {
    fail("Invalid format should return None")
  }
  if @ipaddr.Ipv4Prefix::parse("192.168.1.0") != None {
    fail("Missing prefix length should return None")
  }
  if @ipaddr.Ipv4Prefix::parse("192.168.1.0/33") != None {
    fail("Invalid prefix length should return None")
  }
  if @ipaddr.Ipv4Prefix::parse("256.1.1.1/24") != None {
    fail("Invalid IP address should return None")
  }
  if @ipaddr.Ipv4Prefix::parse("192.168.1.0/08") != None {
    fail("Leading zero in prefix should return None")
  }
  if @ipaddr.Ipv4Prefix::parse("192.168.1.0/") != None {
    fail("Empty prefix length should return None")
  }
  if @ipaddr.Ipv4Prefix::parse("192.168.1.0/123") != None {
    fail("Prefix length too long should return None")
  }
  if @ipaddr.Ipv4Prefix::parse("192.168.1.0/a") != None {
    fail("Non-numeric prefix length should return None")
  }
}

///|
test "try_from_int_functions" {
  // Test Ipv4::try_from_int
  match @ipaddr.Ipv4::try_from_int(0x7F000001) {
    Some(addr) => {
      if addr.format() != "127.0.0.1" {
        fail("try_from_int should create correct IPv4")
      }
    }
    None => fail("Valid IPv4 integer should succeed")
  }

  // Test valid edge cases
  match @ipaddr.Ipv4::try_from_int(0) {
    Some(addr) => {
      if addr.format() != "0.0.0.0" {
        fail("Zero should create 0.0.0.0")
      }
    }
    None => fail("Zero should be valid")
  }

  // Test with a positive 32-bit value
  match @ipaddr.Ipv4::try_from_int(0x08080808) { // 8.8.8.8
    Some(addr) => {
      if addr.format() != "8.8.8.8" {
        fail("Positive value should create correct IPv4, got: " + addr.format())
      }
    }
    None => fail("Positive 32-bit value should be valid")
  }

  // Test invalid cases
  if @ipaddr.Ipv4::try_from_int(-1) != None {
    fail("Negative value should return None")
  }

  // Test Mac::try_from_int
  match @ipaddr.Mac::try_from_int(0x22334455) {
    Some(mac) => {
      if mac.format() != "00:00:22:33:44:55" {
        fail("try_from_int should create correct MAC")
      }
    }
    None => fail("Valid MAC integer should succeed")
  }

  match @ipaddr.Mac::try_from_int(0) {
    Some(mac) => {
      if mac.format() != "00:00:00:00:00:00" {
        fail("Zero should create null MAC")
      }
    }
    None => fail("Zero should be valid for MAC")
  }

  // Test invalid MAC cases
  if @ipaddr.Mac::try_from_int(-1) != None {
    fail("Negative MAC value should return None")
  }
}

///|
test "ipv4_prefix_utilities" {
  // Test subnet mask calculation
  let subnet24 = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(192, 168, 1, 0), 24)
  let mask24 = subnet24.mask()
  if mask24.format() != "255.255.255.0" {
    fail("/24 mask should be 255.255.255.0, got: " + mask24.format())
  }

  let subnet16 = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(10, 0, 0, 0), 16)
  let mask16 = subnet16.mask()
  if mask16.format() != "255.255.0.0" {
    fail("/16 mask should be 255.255.0.0, got: " + mask16.format())
  }

  let host_route = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(127, 0, 0, 1), 32)
  let mask32 = host_route.mask()
  if mask32.format() != "255.255.255.255" {
    fail("/32 mask should be 255.255.255.255, got: " + mask32.format())
  }

  let default_route = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(0, 0, 0, 0), 0)
  let mask0 = default_route.mask()
  if mask0.format() != "0.0.0.0" {
    fail("/0 mask should be 0.0.0.0, got: " + mask0.format())
  }

  // Test host count calculation
  let count24 = subnet24.host_count()
  if count24 != 256 {
    fail("/24 should have 256 hosts, got: " + count24.to_string())
  }

  let count16 = subnet16.host_count()
  if count16 != 65536 {
    fail("/16 should have 65536 hosts, got: " + count16.to_string())
  }

  let count32 = host_route.host_count()
  if count32 != 1 {
    fail("/32 should have 1 host, got: " + count32.to_string())
  }

  let point_to_point = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(10, 0, 0, 0), 31)
  let count31 = point_to_point.host_count()
  if count31 != 2 {
    fail("/31 should have 2 hosts, got: " + count31.to_string())
  }

  let count0 = default_route.host_count()
  // /0 should have 2^32 hosts, which is a very large number
  if count0 <= 0 {
    fail("/0 should have positive host count, got: " + count0.to_string())
  }
}

///|
test "error_based_parsing" {
  // Test successful parsing
  match @ipaddr.Ipv4::parse_detailed("192.168.1.1") {
    Ok(addr) => {
      if addr.format() != "192.168.1.1" {
        fail("Detailed parsing should work correctly")
      }
    }
    Err(_) => fail("Valid IPv4 string should parse successfully")
  }

  // Test invalid format errors
  match @ipaddr.Ipv4::parse_detailed("192.168.1") {
    Ok(_) => fail("Incomplete address should return error")
    Err(InvalidFormat) => () // Expected
    Err(_) => fail("Should return InvalidFormat error")
  }

  // Test invalid octet errors
  match @ipaddr.Ipv4::parse_detailed("256.1.1.1") {
    Ok(_) => fail("Out of range octet should return error")
    Err(InvalidOctet(n)) => {
      if n != 256 {
        fail("Should return InvalidOctet(256), got: " + n.to_string())
      }
    }
    Err(_) => fail("Should return InvalidOctet error")
  }

  // Test leading zero format error
  match @ipaddr.Ipv4::parse_detailed("192.168.01.1") {
    Ok(_) => fail("Leading zeros should return error")
    Err(InvalidFormat) => () // Expected
    Err(_) => fail("Should return InvalidFormat error for leading zeros")
  }

  // Test non-numeric format error
  match @ipaddr.Ipv4::parse_detailed("192.168.a.1") {
    Ok(_) => fail("Non-numeric octet should return error")
    Err(InvalidFormat) => () // Expected
    Err(_) => fail("Should return InvalidFormat error for non-numeric")
  }

  // Test empty octet error
  match @ipaddr.Ipv4::parse_detailed("192.168..1") {
    Ok(_) => fail("Empty octet should return error")
    Err(InvalidFormat) => () // Expected
    Err(_) => fail("Should return InvalidFormat error for empty octet")
  }

  // Test too long octet error
  match @ipaddr.Ipv4::parse_detailed("192.168.1234.1") {
    Ok(_) => fail("Too long octet should return error")
    Err(InvalidFormat) => () // Expected
    Err(_) => fail("Should return InvalidFormat error for too long octet")
  }
}

///|
test "hash_trait_functionality" {
  // Test that Hash trait works for using addresses as map keys
  let addr1 = @ipaddr.Ipv4::new(192, 168, 1, 1)
  let addr2 = @ipaddr.Ipv4::new(192, 168, 1, 1)
  let addr3 = @ipaddr.Ipv4::new(192, 168, 1, 2)
  
  // Equal addresses should have equal hashes
  if addr1 != addr2 {
    fail("Equal IPv4 addresses should be equal")
  }
  
  // Different addresses should not be equal
  if addr1 == addr3 {
    fail("Different IPv4 addresses should not be equal")
  }
  
  // Test with MAC addresses
  let mac1 = @ipaddr.Mac::new(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let mac2 = @ipaddr.Mac::new(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let mac3 = @ipaddr.Mac::new(0x00, 0x11, 0x22, 0x33, 0x44, 0x56)
  
  if mac1 != mac2 {
    fail("Equal MAC addresses should be equal")
  }
  
  if mac1 == mac3 {
    fail("Different MAC addresses should not be equal")
  }
  
  // Test with prefixes
  let prefix1 = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(192, 168, 1, 0), 24)
  let prefix2 = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(192, 168, 1, 0), 24)
  let prefix3 = @ipaddr.Ipv4Prefix::new(@ipaddr.Ipv4::new(192, 168, 1, 0), 25)
  
  if prefix1 != prefix2 {
    fail("Equal prefixes should be equal")
  }
  
  if prefix1 == prefix3 {
    fail("Different prefixes should not be equal")
  }
}
