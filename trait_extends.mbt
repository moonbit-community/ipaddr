// Explicit promotion of trait implementations to regular methods.
//
// Historically MoonBit implicitly promoted the methods of an `impl Trait for T`
// declaration into regular methods on `T`, so callers could write `x.compare(y)`
// or `x.to_string()`. That implicit promotion is deprecated, so the promotions
// this package has always exposed are now spelled out here. These declarations
// are behavior-preserving: they keep exactly the dot-syntax methods that were
// previously available on the public types.

///|
pub extend IpAddrError with Eq::{equal, not_equal}

///|
pub extend IpAddrError with Hash::{hash, hash_combine}

///|
pub extend IpAddrError with @debug.Debug::{to_repr}

///|
pub extend IpAddrError with Show::{output, to_string}

///|
pub extend Ipv4 with Eq::{equal, not_equal}

///|
pub extend Ipv4 with Compare::{compare, op_ge, op_gt, op_le, op_lt}

///|
pub extend Ipv4 with Hash::{hash, hash_combine}

///|
pub extend Ipv4 with @debug.Debug::{to_repr}

///|
pub extend Ipv4 with Show::{output, to_string}

///|
pub extend Ipv4Prefix with Eq::{equal, not_equal}

///|
pub extend Ipv4Prefix with Compare::{compare, op_ge, op_gt, op_le, op_lt}

///|
pub extend Ipv4Prefix with Hash::{hash, hash_combine}

///|
pub extend Ipv4Prefix with @debug.Debug::{to_repr}

///|
pub extend Ipv4Prefix with Show::{output, to_string}

///|
pub extend Mac with Eq::{equal, not_equal}

///|
pub extend Mac with Compare::{compare, op_ge, op_gt, op_le, op_lt}

///|
pub extend Mac with Hash::{hash, hash_combine}

///|
pub extend Mac with @debug.Debug::{to_repr}

///|
pub extend Mac with Show::{output, to_string}
