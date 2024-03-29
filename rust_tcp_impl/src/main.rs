use std::io;

use tun_tap::Mode::Tun;

fn main() -> io::Result<()> {
    let nic = tun_tap::Iface::new("tun0", Tun).unwrap();
    let mut buf = [0u8; 1504];
    loop {
        let n_bytes = nic.recv(&mut buf[..]).unwrap();
        let _eth_flags = u16::from_be_bytes([buf[0], buf[1]]);
        let eth_proto = u16::from_be_bytes([buf[2], buf[3]]);
        if eth_proto != 0x0800 {
            // no ipv4
            continue;
        }
        
        match etherparse::Ipv4HeaderSlice::from_slice(&buf[4..n_bytes]) {
            Ok(p) => {
                let src = p.source_addr();
                let dst = p.destination_addr();
                let proto = p.protocol();
                eprintln!(
                    "{} -> {} {:?}b of protocol {:x?}",
                    src,
                    dst,
                    p.payload_len().unwrap(),
                    proto,
                );
            }
            Err(e) => {
                eprintln!("ignoring weird packet {}", e)
            }
        }
    }
}
