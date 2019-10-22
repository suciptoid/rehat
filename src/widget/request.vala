/* requestpane.vala
 *
 * Copyright 2019 Sucipto <hi@sucipto.id>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Rehat.Widget {
    public class Request : Gtk.Box {
        Widget.UrlBar urlbar;

        public Request(){
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing:0
            );
        }

        construct {
            // URL Bar
            urlbar = new Widget.UrlBar();
            this.add(urlbar);

            // Tab Body / Header

            this.set_size_request(300,-1);
        }
    }
}
