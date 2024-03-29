#!/bin/bash
cargo b --release
sudo setcap 'cap_net_admin=eip' target/release/rust_tcp_impl
./target/release/rust_tcp_impl &
pid=$!
sudo ip addr add 10.0.0.1/24 dev tun0
sudo ip link set up dev tun0
trap 'kill $pid' INT TERM
wait $pid