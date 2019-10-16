/* DropDown.vala
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
    public class DropDown : Gtk.ComboBox {
        Gtk.ListStore store;
	    string[] http_methods = {"GET","POST","DELETE","PATCH","PUT"};
        enum Column {
            METHOD
        }

        construct {
            store = new Gtk.ListStore(1, typeof(string));
            for (int i = 0; i < http_methods.length; i++) {
                Gtk.TreeIter iter;
                store.append(out iter);
                store.set(iter, Column.METHOD, http_methods[i]);
            }

            var cell = new Gtk.CellRendererText();
            this.pack_start(cell,false);
            this.set_attributes(cell,"text",Column.METHOD);

            this.model = store;
            //this.set_active(1);
        }

        public string get_method() {
            return http_methods[this.active];
        }
    }
}
