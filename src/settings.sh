#!/bin/sh
################################################################################
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

. /etc/profile

oe_setup_addon tb.settings

# sshd
SSHD_CONF="/storage/.cache/services/sshd.conf"
rm -f $SSHD_CONF
if [ "$SSHD_ENABLED" = "true" ] ; then
  if [ "$SSHD_SECURE" = "true" ] ; then
    echo "SSH_ARGS=\"-o 'PasswordAuthentication no'\"" > $SSHD_CONF
  else
    echo "SSH_ARGS=\"\"" > $SSHD_CONF
  fi
fi

systemctl restart sshd.service

# network
NET_CONF="/storage/.config/network/eth0.network"
rm -f $NET_CONF
if [ "$NET_METHOD" = "manual" ] ; then
  mkdir -p $(dirname $NET_CONF)
  sed $(dirname $0)/resources/eth0.network \
      -e "s|@NET_ADDRESS@|$NET_ADDRESS|" \
      -e "s|@NET_PREFIXLEN@|$NET_PREFIXLEN|" \
      -e "s|@NET_PREFIXLEN@|$NET_PREFIXLEN|" \
      -e "s|@NET_GATEWAY@|$NET_GATEWAY|" \
      -e "s|@NET_DNS1@|$NET_DNS1|" \
      -e "s|@NET_DNS2@|$NET_DNS2|" \
      > $NET_CONF
fi

systemctl restart systemd-networkd.service
