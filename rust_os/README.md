Operating system on rust

создание(кросс компиляция) исполняемого файла для arm
```shell
cargo build --release --target thumbv7em-none-eabihf
```
создание исполняемого файла для текущей платформы
```shell
cargo rustc --release -- -C link-arg=-nostartfiles
```
