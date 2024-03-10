use std::io;
use tun_tap::Mode::Tun;

fn main() -> io::Result<()> {
    let nic = tun_tap::Iface::new("tun0", Tun).unwrap();
    let mut buf = [0u8; 1504];
    loop {
        let n_bytes = nic.recv(&mut buf[..]).unwrap();
        let flags = u16::from_be_bytes([buf[0], buf[1]]);
        let proto = u16::from_be_bytes([buf[2], buf[3]]);
        eprintln!(
            "read {} bytes (flags: {:x}, proto: {:x}): {:x?}",
            n_bytes - 4,
            flags,
            proto,
            &buf[4..n_bytes]
        );
    }
    Ok(())
}
