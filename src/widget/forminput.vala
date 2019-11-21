/* forminput.vala
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
    public class FormInput : Gtk.Box {
        public Gtk.Entry key;
        public Gtk.Entry val;
        Gtk.Button delete_button;

        public FormInput() {
            Object(
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 0
            );
        }

        construct {
            key = new Gtk.Entry();
            key.placeholder_text = "Name";
            key.margin_end = 4;
            key.hexpand = true;

            val = new Gtk.Entry();
            val.placeholder_text = "Value";
            val.margin_end = 4;
            val.hexpand = true;

            delete_button = new Gtk.Button.from_icon_name("window-close-symbolic");
            delete_button.get_style_context().add_class("destructive-action");
            delete_button.clicked.connect(() => {
                this.destroy();
            });

            this.add(key);
            this.add(val);
            this.add(delete_button);
        }
    }
}
