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

ADDON_NAME=tb.settings

BUILDDIR=build
ADDONDIR=/usr/share/kodi/addons

################################################################################

all: $(BUILDDIR)/$(ADDON_NAME)

install: $(BUILDDIR)/$(ADDON_NAME)
	mkdir -p $(DESTDIR)/$(ADDONDIR)
	cp -R $(BUILDDIR)/$(ADDON_NAME) $(DESTDIR)/$(ADDONDIR)

	mkdir -p $(DESTDIR)/usr/bin
	cp settings-mon $(DESTDIR)/usr/bin

$(BUILDDIR)/$(ADDON_NAME):
	$(CC) -DWORK_DIR=\"/storage/.kodi/userdata/addon_data/$(ADDON_NAME)\" \
	      -DRESTART_SCRIPT=\"$(ADDONDIR)/$(ADDON_NAME)/restart.sh\" \
              settings-mon.c -o settings-mon

	mkdir -p $(BUILDDIR)/$(ADDON_NAME)
	cp -R src/* $(BUILDDIR)/$(ADDON_NAME)

	sed -e "s,@ADDONNAME@,$(ADDON_NAME),g" \
	    -i $(BUILDDIR)/$(ADDON_NAME)/addon.xml
