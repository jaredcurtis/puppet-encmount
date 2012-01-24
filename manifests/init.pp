# Class: encmount
#
#   This module manages mounting encrypted disks using LUKS.
#
#   Jared Curtis <jared@ncircle.com>
#   2012-01-23
#
#   Tested platforms:
#    - CentOS 5.x
#
# Parameters:
#
# Actions:
#
# Uses LUKS to mount an encrypted volume
#
# Requires:
#
#   cryptsetup
#
# Sample Usage:
#
# encmount::mount { '/mnt/test':
#   fstype => 'ext3',
#   device => '/dev/sdb1',
#   mapper => 'enc_sdb1',
#   key    => '1234!@#$',
# }
class encmount {
  include cryptsetup
}
