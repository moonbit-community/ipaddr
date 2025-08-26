- ## Interface Design Review TODOs
- The following checklist contains potential improvements to the public API generated in `pkg.generated.mbti`. Please review each item and mark the ones that make sense to implement.
- [x] change IPV4 each field from Int to Byte
- [x] **Consolidate constructors into associated `new` functions**
  - Replace global `ipv4`, `ipv4_prefix`, and `mac` with `Ipv4::new`, `Ipv4Prefix::new`, and `Mac::new` to align with OO style.

- [x] **Provide parsing from string helpers**
  - Add `Ipv4::parse(String) -> Option<Ipv4>`
  - Add `Ipv4Prefix::parse(String) -> Option<Ipv4Prefix>` (supports "192.168.1.0/24" syntax)
  - Add `Mac::parse(String) -> Option<Mac>`

- [ ] **Expose `to_string` methods via `Show` trait only**
  - Evaluate whether explicit `format` methods are redundant given `Show` trait; consider deprecating `format`.

- [ ] **Add `try_from_int` variants for safe conversion**
  - Instead of panicking on invalid input, provide `Ipv4::try_from_int(Int) -> Option<Ipv4>` etc.

- [ ] **Rename `is_valid_ipv4_octet` to `Ipv4::is_valid_octet` and make it private**
  - Hide low-level helper from public surface; expose higher-level validation instead.

- [ ] **Add network utility helpers to `Ipv4Prefix`**
  - e.g. `hosts() -> Iterator<Ipv4>` to iterate usable hosts
  - `mask() -> Ipv4` to retrieve subnet mask.


- [ ] **Add error enum for parsing/validation errors**
  - Centralise error handling instead of returning `Option`.

- [ ] **Document trait implementations in interface**
  - Ensure `Hash` or `Ord` traits are implemented where logical.

- [ ] **Re-generate interface after adopting changes**
  - Run `moon info` to update `pkg.generated.mbti`.
