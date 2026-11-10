// each feature pulls in another libc import, changing the indirect-symbol count's parity
unsafe extern "C" {
  fn getpid() -> i32;
  fn getppid() -> i32;
  fn getuid() -> u32;
  fn getgid() -> u32;
  static environ: *const *const i8;
}

#[unsafe(no_mangle)]
pub extern "C" fn probe() -> i64 {
  let mut total = unsafe { getpid() } as i64;
  if cfg!(feature = "imports2") { total += unsafe { getppid() } as i64 }
  if cfg!(feature = "imports3") { total += unsafe { getuid() } as i64 }
  if cfg!(feature = "imports4") { total += unsafe { getgid() } as i64 }
  if cfg!(feature = "data") { total += unsafe { environ }.is_null() as i64 }
  total
}
