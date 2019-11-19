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
        public string body;

        private Gtk.Box header_box;
        public Request(){
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing:0
            );
        }

        construct {
            // Body Stack
            var stack = new Gtk.Stack();
            var stack_scroll = new Gtk.ScrolledWindow(null,null);
            stack_scroll.add(stack);
            stack.vexpand = true;
            //stack.margin = 8;

            // Body Type Text / JSON
            var body_type_text = new Gtk.SourceView();
            body_type_text.set_wrap_mode(Gtk.WrapMode.WORD);
            body_type_text.auto_indent = true;
            body_type_text.show_line_numbers = true;

            //body_stack_content.add(body_type_text);
            stack.add_titled(body_type_text,"body_text","Body");

            //TODO: se dynamic content
            var lang_mgr = new Gtk.SourceLanguageManager();
            var body_text_buff = new Gtk.SourceBuffer.with_language(lang_mgr.get_language("json"));
            body_text_buff.highlight_syntax = true;
            body_text_buff.highlight_matching_brackets = false;
            body_text_buff.style_scheme = (new Gtk.SourceStyleSchemeManager()).get_scheme("kate");
            body_type_text.buffer = body_text_buff;

            body_text_buff.changed.connect(() => {
                //print("Request body changed: %s\n".printf(body_type_text.buffer.text));
                this.body = body_text_buff.text;
            });


            // Body Type Form
            var body_type_form = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            //stack.add_titled(body_type_form,"body_form","Body");

            // Query Tab
            var tab_query = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            tab_query.add(new Gtk.Label("Query"));
            //stack.add_titled(tab_query, "tab_query","Query");

            // Header Tab
            var tab_header = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            stack.add_titled(tab_header, "tab_header","Header");
            this.create_header_form(tab_header);

            // Tab Switcher
            var switcher = new Gtk.StackSwitcher();
            switcher.stack = stack;
            switcher.margin_bottom = 8;
            switcher.halign = Gtk.Align.CENTER;

            var body_type = new Gtk.ComboBoxText();
            body_type.append_text("JSON");
            body_type.append_text("Form Data");
            body_type.set_active(0);
            body_type.halign = Gtk.Align.START;
            body_type.margin_end = 8;


            // Switcher Box
            var switcher_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
            switcher_box.add(body_type);
            //switcher_box.add(switcher);
            switcher_box.margin_bottom = 8;
            switcher_box.hexpand = true;
            switcher_box.halign = Gtk.Align.CENTER;


            this.set_size_request(-1,200);
            this.add(switcher);
            this.add(stack_scroll);
        }

        private void create_header_form(Gtk.Box parent) {
            parent.margin_start = 16;
            parent.margin_end = 16;

            header_box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            parent.add(header_box);

            var add_btn = new Gtk.Button.with_label("Add Header");
            parent.add(add_btn);

            // TODO: Remove after has dynamic content
            this.add_header("Content-Type","application/json");

            add_btn.clicked.connect(() => {
                this.add_header("","");
            });

        }

        public Soup.MessageHeaders get_headers() {
            var headers = new Soup.MessageHeaders(Soup.MessageHeadersType.REQUEST);
            header_box.foreach((h) => {
                var header = h as Widget.HeaderInput;
                if (header.entry.text != "" && header.val.text != "") {
                    headers.append(header.entry.text,header.val.text);
                    print("Add to header: %s => %s\n".printf(header.entry.text,header.val.text));
                }
            });

            return headers;
        }

        public void add_header(string key, string val) {
            var header = new Widget.HeaderInput();
            header.entry.text = key;
            header.val.text = val;
            header.margin_bottom = 4;
            header_box.add(header);
            header_box.show_all();
        }


    }
}
