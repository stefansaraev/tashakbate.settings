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

if [ -n "$SSHD_ENABLED" ] ; then
  SSHD_CONF="/storage/.cache/service.sshd.conf"
  rm -f $SSHD_CONF
  if [ "$SSHD_ENABLED" = "true" ] ; then
    if [ "$SSHD_SECURE" = "true" ] ; then
      echo "SSH_ARGS=\"-o 'PasswordAuthentication no'\"" > $SSHD_CONF
    else
      echo "SSH_ARGS=\"\"" > $SSHD_CONF
    fi
  fi
  systemctl restart sshd.service
fi

if [ "$NET_METHOD" = "manual" ] ; then
  echo -n > /storage/.cache/net.static
  echo "NET_ADDRESS=$NET_ADDRESS" >> /storage/.cache/net.static
  echo "NET_NETMASK=$NET_NETMASK" >> /storage/.cache/net.static
  echo "NET_GATEWAY=$NET_GATEWAY" >> /storage/.cache/net.static
  echo "NET_DNS1=$NET_DNS1" >> /storage/.cache/net.static
  echo "NET_DNS2=$NET_DNS2" >> /storage/.cache/net.static
  systemctl stop udhcpc.service
  systemctl restart net-static.service
else
  rm -f /storage/.cache/net.static
  systemctl restart udhcpc.service
fi
