#!/bin/bash

# -r 20 -u 512 -v 512 : 1557.93 sec (25.9655 min)
# -r 20 -u 512 -v 256 : 1543.63 sec (25.7272 min)

# -r 40 -u 512 -v 128 : 1573.59 sec (26.2265 min)
# -r 40 -u 512 -v 256 : 1540.29 sec (25.6715 min)
# -r 40 -u 512 -v 512 : 1545.64 sec (25.7606 min)

# -r 38 -u 256 -v 128 : 1475.68 sec (24.5947 min)
# -r 38 -u 256 -v 256 : 1465.86 sec (24.431 min)

# -r 40 -u 256 -v 256 : 1461.54 sec (24.3591 min)
# -r 40 -u 256 -v 128 : 1496.94 sec (24.949 min)

./chia_plot -n 1 -r 38 -u 256 -v 256 -w -t /mnt/md0/tmp/ -2 /mnt/ram/ -d /mnt/md0/plots/ -f b3...c -p ab65...623