# ipaddr: IP and MAC address manipulation for MoonBit

A MoonBit library for manipulation of IP (IPv4/IPv6) and MAC address representations, ported from the OCaml [ipaddr library](https://github.com/mirage/ocaml-ipaddr).

## Features

- IPv4 and IPv6 address support
- IPv4 and IPv6 CIDR prefix support  
- MAC-48 (Ethernet) address support
- Address parsing from strings
- Address formatting to strings
- Address comparison and ordering
- Subnet operations and containment checks
- Comprehensive test suite

## Usage

```moonbit
test "readme_examples" {
  // IPv4 addresses
  let addr = @ipaddr.ipv4(192, 168, 1, 1)
  let formatted = addr.format()
  if formatted != "192.168.1.1" {
    fail("IPv4 formatting failed")
  }

  // IPv4 CIDR prefixes
  let prefix = @ipaddr.ipv4_prefix(@ipaddr.ipv4(192, 168, 1, 0), 24)
  let contains = prefix.contains(addr)
  if not(contains) {
    fail("Address should be contained in prefix")
  }

  // MAC addresses
  let mac_addr = @ipaddr.mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
  let formatted_mac = mac_addr.format()
  if formatted_mac != "00:11:22:33:44:55" {
    fail("MAC formatting failed")
  }
}
```

## License

ISC License (same as the original OCaml library)