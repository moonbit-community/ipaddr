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
// IPv4 addresses
let addr = @lib.parse_ipv4("192.168.1.1")
let formatted = @lib.format_ipv4(addr)

// IPv6 addresses  
let addr6 = @lib.parse_ipv6("2001:db8::1")
let formatted6 = @lib.format_ipv6(addr6)

// CIDR prefixes
let prefix = @lib.parse_ipv4_prefix("192.168.1.0/24")
let contains = @lib.ipv4_prefix_contains(prefix, addr)

// MAC addresses
let mac = @lib.parse_mac("00:11:22:33:44:55")
let formatted_mac = @lib.format_mac(mac)
```

## License

ISC License (same as the original OCaml library)