добавляю разрешения процессу на манипулирование сетевыми интерфейсами:
```shell
sudo setcap 'cap_net_admin=eip' target/release/rust_tcp_impl
```
просмотр разрешений файла, при запуске процесс которого будет их иметь:
```shell
getcap target/release/rust_tcp_impl
```

добавить ip адрес сетевому интерфейсу tun0
```shell
sudo ip addr add 192.168.0.1/24 dev tun0
```
включить сетевой интерфейс tun0
```shell
sudo ip link set up dev tun0
```
отправка ICMP пакета на инерфейс tun0 по ip адресу 192.168.0.2
```shell
ping -I tun0 192.168.0.2
```
подключиться по протоколу tcp к порту 80
```shell
nc 192.168.0.2 80
```
захватывать и выводить пакеты интерфейса tun0
```shell
sudo tshark -i tun0
```


найти процесс и его pid, у которого в строке запуска этого процесса было слово target
```shell
 pgrep -afi target
```
остановить процесс
```shell
kill <pid>
```
