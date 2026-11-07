# NVMe Temperature

An Omarchy 4.5 top-bar widget that displays the temperature of each NVMe drive. Hover over the readings to see which drive each temperature belongs to.

The widget reads Linux hardware sensors every five seconds. It needs no administrator access or network connection to run.

## Install

```sh
omarchy plugin add https://github.com/norzam/nvme-temperature --enable
```

To place it next to the system monitor widget:

```sh
omarchy bar move norzam.nvme-temperature --after omarchy.monitor
```

## Remove

```sh
omarchy plugin remove norzam.nvme-temperature
```
