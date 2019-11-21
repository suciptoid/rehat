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
        private Gtk.Box         body_box;
        private Gtk.Box         header_box;
        public  string          request_body_type;

        private Gtk.Box         body_type_form;
        private Gtk.SourceView  body_type_text;

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

            // Body Box
            body_box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            stack.add_titled(body_box, "body", "Body");

            // Query Tab
            var tab_query = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            tab_query.add(new Gtk.Label("Query"));

            // Header Tab
            var tab_header = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            stack.add_titled(tab_header, "tab_header","Header");
            this.create_header_form(tab_header);

            // Tab Switcher
            var switcher = new Gtk.StackSwitcher();
            switcher.stack = stack;
            switcher.margin_bottom = 8;
            switcher.halign = Gtk.Align.CENTER;

            // Body Type
            var body_type = new Gtk.ComboBoxText();
            body_type.append_text("Form Data");
            body_type.append_text("JSON");
            body_type.set_active(0);

            body_type.halign = Gtk.Align.START;
            body_type.margin_bottom = 8;
            var body_type_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
            body_type_box.add(body_type);

            this.switch_body_form(Soup.FORM_MIME_TYPE_URLENCODED);
            body_type.changed.connect(() => {
                switch (body_type.active) {
                    case 0:
                        this.switch_body_form(Soup.FORM_MIME_TYPE_URLENCODED);
                        break;
                    case 1:
                        this.switch_body_raw("application/json");
                        break;
                }
            });


            // Switcher Box
            var switcher_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
            switcher_box.margin_bottom = 8;
            switcher_box.hexpand = true;
            switcher_box.margin_start = 8;
            switcher_box.margin_end = 8;
            switcher_box.homogeneous = true;

            switcher_box.add(body_type_box);
            switcher_box.add(switcher);
            switcher_box.add(new Gtk.Box(Gtk.Orientation.HORIZONTAL,0)); // Add empty space

            // On stack changed
            stack.notify.connect((s,p) => {
                if (p.name == "visible-child-name") {
                    if(stack.visible_child_name == "body"){
                        body_type.set_visible(true);
                    } else {
                        body_type.set_visible(false);
                    }
                }
            });

            this.set_size_request(-1,200);
            this.add(switcher_box);
            this.add(stack_scroll);
        }

        private void create_header_form(Gtk.Box parent) {
            parent.margin_start = 8;
            parent.margin_end = 8;

            header_box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            parent.add(header_box);

            var add_btn = new Gtk.Button.with_label("Add Header");
            parent.add(add_btn);

            add_btn.clicked.connect(() => {
                this.add_header("","");
            });
        }

        public Soup.MessageHeaders get_headers() {
            var headers = new Soup.MessageHeaders(Soup.MessageHeadersType.REQUEST);
            header_box.foreach((h) => {
                var header = h as Widget.HeaderInput;
                if (header.entry.text != "" && header.val.text != "") {
                    headers.append(header.entry.text, header.val.text);
                    print("Add to header: %s => %s\n".printf(header.entry.text,header.val.text));
                }
            });

            return headers;
        }

        public void add_header(string key, string val) {
            this.remove_header(key);

            var header = new Widget.HeaderInput();
            header.entry.text = key;
            header.val.text = val;
            header.margin_bottom = 4;
            header_box.add(header);
            header_box.show_all();
        }

        public void remove_header(string key) {
            header_box.foreach((child) => {
                var header = child as Widget.HeaderInput;
                if (header.entry.text == key) {
                    child.destroy();
                }
            });
        }

        // Example: switch_body_raw("application/json")
        public void switch_body_raw(string content_type) {
            this.request_body_type = content_type;
            this.add_header("Content-Type", content_type);

            body_type_text = new Gtk.SourceView();
            body_type_text.set_wrap_mode(Gtk.WrapMode.WORD);
            body_type_text.auto_indent = true;
            body_type_text.expand = true;
            body_type_text.margin = 8;
            body_type_text.show_line_numbers = true;

            var lang_mgr = new Gtk.SourceLanguageManager();
            var body_text_buff = new Gtk.SourceBuffer.with_language(lang_mgr.get_language("json"));
            body_text_buff.highlight_syntax = true;
            body_text_buff.highlight_matching_brackets = false;
            body_text_buff.style_scheme = (new Gtk.SourceStyleSchemeManager()).get_scheme("kate");
            body_type_text.buffer = body_text_buff;

            body_box.foreach((child) => {
                child.destroy();
            });
            body_box.add(body_type_text);
            body_box.show_all();
        }

        public void switch_body_form(string content_type) {
            this.request_body_type = content_type;
            this.add_header("Content-Type", content_type);

            // Body Type Form
            body_type_form = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            body_type_form.margin_start = 8;
            body_type_form.margin_end = 8;

            var form_add_button = new Gtk.Button.with_label("Add Form");
            form_add_button.margin = 8;
            form_add_button.clicked.connect(() => {
                var input = new Widget.FormInput();
                input.margin_bottom = 4;
                body_type_form.add(input);
                body_type_form.show_all();
            });

            for (int x = 0; x < 2; x++) {
                var input = new Widget.FormInput();
                input.margin_bottom = 4;
                body_type_form.add(input);
                body_type_form.show_all();
            }

            body_box.foreach((child) => {
                child.destroy();
            });
            body_box.add(body_type_form);
            body_box.add(form_add_button);
            body_box.show_all();
        }

        public Soup.MessageBody? get_body() {

            if (this.request_body_type == Soup.FORM_MIME_TYPE_URLENCODED) {
                HashTable<string, string> form = new HashTable<string, string> (str_hash, str_equal);
                body_type_form.foreach((child) => {
                    var input = child as Widget.FormInput;
                    //print("Form input: %s\n".printf(input.val.text));
                    if (input.val.text != "" && input.key.text != "") {
                        form.insert(input.key.text,input.val.text);
                    }
                });

                var form_data = Soup.Form.encode_hash(form);
                print("Form data: %s\n".printf(form_data));

                var body = new Soup.MessageBody();
                body.data = form_data.data;
                body.length = form_data.length;
                return body;
            } else if(this.request_body_type == "application/json" || this.request_body_type == "application/text") {
                var body = new Soup.MessageBody();
                var text = this.body_type_text.buffer.text;
                body.data = text.data;
                body.length = text.length;
                return body;
            } else {
                return null;
            }
        }


    }
}
