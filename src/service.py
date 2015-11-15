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

import xbmc
import xbmcaddon
import xbmcgui
import subprocess

__scriptid__ = '@ADDONNAME@'
__addon__ = xbmcaddon.Addon(id=__scriptid__)
__cwd__ = __addon__.getAddonInfo('path')

def execute(command_line):
    try:
        process = subprocess.Popen(command_line, shell=True, close_fds=True)
        process.wait()
    except Exception, e:
        pass

class Monitor(xbmc.Monitor):
    def onSettingsChanged(self):
        execute(__cwd__ + "/settings.sh")

monitor = Monitor()
monitor.waitForAbort()
