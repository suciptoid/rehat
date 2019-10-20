/* requestform.vala
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
    public class RequestForm : Gtk.Popover {
        public string body { get; set; }
        private HashTable<string,string> headers = new HashTable<string,string>(str_hash, str_equal);

        construct {
            headers.insert("Content","val");
            headers.insert("Content2","val");
            headers.insert("Content3","val");
            var vbox_pop = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            vbox_pop.margin = 4;

            // Stack
            var stack = new Gtk.Stack();
            var stack_switcher = new Gtk.StackSwitcher();
            stack_switcher.stack = stack;

            // Request Body
            var body_box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);

            // Body Type Select
            var body_select = new Gtk.ComboBoxText();
            body_select.margin_top = 4;
            body_select.margin_bottom = 4;

            string[] body_type = {"JSON","Text / Raw", "Form Data", "Multipart From"};
            for (int i = 0; i <= body_type.length; i++) {
                body_select.insert_text(i, body_type[i]);
            }
            body_select.set_active(0);

            // Body Text/JSON View
            var body_text = new Gtk.SourceView();

            var body_scroll = new Gtk.ScrolledWindow(null, null);
            body_scroll.add(body_text);
            body_scroll.height_request = 300;

            // Buffer
            var text_buff = new Gtk.SourceBuffer(null);
            body_text.buffer = text_buff;

            var scheme = new Gtk.SourceStyleSchemeManager();
            text_buff.style_scheme = scheme.get_scheme("builder");
            text_buff.changed.connect(() => {
                print("RequestForm:body:changed:%s\n", text_buff.text);
                this.body = text_buff.text;
            });

            body_box.add(body_select);
            body_box.add(body_scroll);

            stack.add_titled(body_box, "body", "Body");

            var header_box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            header_box.margin_top = 8;

            this.headers.foreach((k,v) => {
                var header_input = new Widget.HeaderInput();
                header_input.margin_bottom = 4;
                header_input.delete_header.connect(() => {
                    header_input.destroy();
                });
                header_box.add(header_input);
            });

            stack.add_titled(header_box, "headers", "Headers");

            vbox_pop.add(stack_switcher);
            vbox_pop.add(stack);

            this.add(vbox_pop);
            this.position = Gtk.PositionType.BOTTOM;
            this.modal = true;
            this.width_request = 600;
        }
    }
}
