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

SSHD_CONF="/storage/.cache/services/sshd.conf"
if [ "$SSHD_SECURE" = "true" ] ; then
  ARGS="SSH_ARGS=\"-o 'PasswordAuthentication no'\""
else
  ARGS="SSH_ARGS=\"\""
fi

if [ "$SSHD_ENABLED" = "true" ] ; then
  echo $ARGS > $SSHD_CONF
else
  rm -f $SSHD_CONF
fi

systemctl restart sshd.service

# network defaults
[ "$NET_ADDRESS" = "0.0.0.0" ] && NET_ADDRESS="192.168.0.100"
[ -z "$NET_PREFIXLEN" ] && NET_PREFIXLEN="24"
[ "$NET_PREFIXLEN" = "0" ] && NET_PREFIXLEN="24"
[ "$NET_GATEWAY" = "0.0.0.0" ] && NET_GATEWAY="192.168.0.1"
[ "$NET_DNS1" = "0.0.0.0" ]    && NET_DNS1="192.168.0.1"
[ "$NET_DNS2" = "0.0.0.0" ]    && NET_DNS1="8.8.4.4"

NET_CONF="/storage/.config/network/eth0.network"
> $NET_CONF
echo "[Match]" >> $NET_CONF
echo "Name=eth0" >> $NET_CONF
echo "" >> $NET_CONF
echo "[Network]" >> $NET_CONF
if [ "$NET_METHOD" = "manual" ] ; then
  echo "Address=$NET_ADDRESS/$NET_PREFIXLEN" >> $NET_CONF
  echo "Gateway=$NET_GATEWAY" >> $NET_CONF
  [ -n "$NET_DNS1" ] && echo "DNS=$NET_DNS1" >> $NET_CONF
  [ -n "$NET_DNS2" ] && echo "DNS=$NET_DNS2" >> $NET_CONF
else
  echo "DHCP=ipv4" >> $NET_CONF
fi

systemctl restart systemd-networkd.service

if [ "$WAIT_NETWORK" = "true" ] ; then
  echo "WAIT_NETWORK_TIME=\"$WAIT_NETWORK_TIME\"" > /storage/.cache/network_wait
else
  rm -f /storage/.cache/network_wait
fi
