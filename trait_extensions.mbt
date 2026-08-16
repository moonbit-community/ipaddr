///|
pub extend IpAddrError with Eq::{not_equal, equal}

///|
pub extend IpAddrError with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend IpAddrError with Hash::{hash, hash_combine}

///|
pub extend Ipv4 with Eq::{not_equal, equal}

///|
pub extend Ipv4 with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend Ipv4 with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Ipv4 with Hash::{hash, hash_combine}

///|
pub extend Ipv4Prefix with Eq::{not_equal, equal}

///|
pub extend Ipv4Prefix with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend Ipv4Prefix with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Ipv4Prefix with Hash::{hash, hash_combine}

///|
pub extend Mac with Eq::{not_equal, equal}

///|
pub extend Mac with Compare::{op_lt, op_le, op_ge, compare, op_gt}

///|
pub extend Mac with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Mac with Hash::{hash, hash_combine}

///|
pub extend IpAddrError with Show::{to_string, output}

///|
pub extend Ipv4 with Show::{to_string, output}

///|
pub extend Ipv4Prefix with Show::{to_string, output}

///|
pub extend Mac with Show::{to_string, output}
