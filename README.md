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
let addr = ipv4(192, 168, 1, 1)
let formatted = format_ipv4(addr)

// IPv4 CIDR prefixes
let prefix = ipv4_prefix(ipv4(192, 168, 1, 0), 24)
let contains = ipv4_prefix_contains(prefix, addr)

// MAC addresses
let mac_addr = mac(0x00, 0x11, 0x22, 0x33, 0x44, 0x55)
let formatted_mac = format_mac(mac_addr)
```

## License

ISC License (same as the original OCaml library)