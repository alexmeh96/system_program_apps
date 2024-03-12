Operating system on rust

создание(кросс компиляция) исполняемого файла для arm
```shell
cargo build --release --target thumbv7em-none-eabihf
```
создание исполняемого файла для текущей платформы
```shell
cargo rustc --release -- -C link-arg=-nostartfiles
```
сборка под целевую платформу, указанную в файл x86_64-test_os.json
```shell
cargo build --target x86_64-test_os.json 
```

### Инструменты для загрузки ядра
```shell
rustup component add llvm-tools-preview
```
```shell
cargo install bootimage
```
сборка ядра и загрузчика в один артифакт
```shell
cargo bootimage
```
запуск артифакта target/x86_64-test_os/debug/bootimage-rust_os.bin в QEMU
```shell
qemu-system-x86_64 -drive format=raw,file=target/x86_64-test_os/debug/bootimage-rust_os.bin
```
PS:

компилирует ядро и загрузчик вместе, и запускает его в QEMU настроена в 
.cargo/config.toml файле проекта, поэтому можно выполнить команду:
```shell
cargo run
```
