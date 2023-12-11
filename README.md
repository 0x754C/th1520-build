# this repo import from revyos

# th1520-build

build overlay for TH1520 boards:

1. LicheePi4A
2. LicheeConsole4A
3. LicheeCluster4A
2. z14inch-m0
2. z14inch-m2


# build

```
sh mklinux.sh
sh mkuboot.sh
```

# install

```
cp -ar overlay th1520-root/
```
