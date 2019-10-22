/* response_pane.vala
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
    public class Response : Gtk.Box {
        public Response()
        {
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing:0
            );
        }
        construct {
            // Text Area
            var text = new Gtk.SourceView();
            text.set_wrap_mode(Gtk.WrapMode.WORD);
            text.auto_indent = true;
            text.highlight_current_line = false;
            text.editable = false;

            var scroll = new Gtk.ScrolledWindow(null, null);
            scroll.add(text);
            scroll.vexpand = true;

            this.add(scroll);

            this.set_size_request(300,-1);
        }
    }
}
