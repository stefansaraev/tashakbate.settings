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

import os
import xbmc
import xbmcaddon
import xbmcgui
import subprocess

__scriptid__ = '@ADDONNAME@'
__addon__ = xbmcaddon.Addon(id=__scriptid__)
__cwd__ = __addon__.getAddonInfo('path')

def export_settings():
    os.environ['SSHD_ENABLED']  = __addon__.getSetting('SSHD_ENABLED')
    os.environ['SSHD_SECURE']   = __addon__.getSetting('SSHD_SECURE')
    os.environ['NET_METHOD']    = __addon__.getSetting('NET_METHOD')
    os.environ['NET_ADDRESS']   = __addon__.getSetting('NET_ADDRESS')
    os.environ['NET_NETMASK']   = __addon__.getSetting('NET_NETMASK')
    os.environ['NET_GATEWAY']   = __addon__.getSetting('NET_GATEWAY')
    os.environ['NET_DNS1']      = __addon__.getSetting('NET_DNS1')
    os.environ['NET_DNS2']      = __addon__.getSetting('NET_DNS2')

def execute(command_line):
    try:
        export_settings()
        process = subprocess.Popen(command_line, shell=True, close_fds=True)
        process.wait()
    except Exception, e:
        pass

class Monitor(xbmc.Monitor):
    def onSettingsChanged(self):
        execute(__cwd__ + "/settings.sh")

monitor = Monitor()
monitor.waitForAbort()
