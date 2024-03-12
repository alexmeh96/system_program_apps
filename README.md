дизасемблировать бинарный elf-файл app используя интеловский синтаксис команд ассемблера:

```shell
objdump -d -M intel app
```


```shell
rustup toolchain list
```

```shell
rustup override set nightly-x86_64-unknown-linux-gnu
```

```shell
rustup target add thumbv7em-none-eabihf
```