скачивание ядра: https://www.kernel.org/

необходимые пакеты для компиляции ядра https://docs.kernel.org/process/changes.html?highlight=minimal+requirements

конфигурация ядра, в результате которой создасться файл .config со всеми параметрами конфигурации
```shell
make nconfig
```
запуск компиляции ядра в 8 потоков
```shell
make -j8
```
после компиляции получится скомпилированный несжатый файл vmlinux или сжатый vmlinuz

если произойдёт какая-то ошибка во время компиляции, 
то чтобы увидеть подробное сообщение об этой ошибке,
нужно выполняить команду make ещё раз

приводит дерево исходного кода в первоначальное состояние, чистит удаляет артифакты сборки,
которые получились во время компиляции. Так же удаляет конфигурационный файл .config
```shell
make mrproper
```

```shell
make clean
```

пакеты для создания iso-образа
```shell
sudo apt install isolinux genisoimage
```

создать iso-образ из скомпилированного ядра
```shell
make isoimage
```
