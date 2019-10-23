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
        public Widget.UrlBar urlbar;

        public Request(){
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing:0
            );
        }

        construct {
            // URL Bar
            urlbar = new Widget.UrlBar();

            // Tab Body / Header
            var tab_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
            tab_box.get_style_context().add_class("linked");
            tab_box.hexpand = true;
            tab_box.halign = Gtk.Align.CENTER;
            tab_box.margin = 8;

            var body_type = new Gtk.ComboBoxText();
            //body_type.append_text("Form Data");
            //body_type.append_text("Multipart");
            body_type.append_text("JSON");
            body_type.set_active(0);

            tab_box.add(body_type);
            tab_box.add(new Gtk.Button.with_label("Header"));

            // Body Stack
            var stack = new Gtk.Stack();
            stack.vexpand = true;
            stack.margin = 8;

            var body_stack_content = new Gtk.ScrolledWindow(null,null);
            var body_type_text = new Gtk.SourceView();
            body_type_text.set_wrap_mode(Gtk.WrapMode.WORD);
            body_type_text.auto_indent = true;

            body_stack_content.add(body_type_text);
            stack.add_named(body_stack_content,"body_text");

            //TODO: se dynamic content
            var lang_mgr = new Gtk.SourceLanguageManager();
            var body_text_buff = new Gtk.SourceBuffer.with_language(lang_mgr.get_language("json"));
            body_text_buff.highlight_syntax = true;
            body_text_buff.style_scheme = (new Gtk.SourceStyleSchemeManager()).get_scheme("kate");
            body_type_text.buffer = body_text_buff;

            this.set_size_request(300,-1);

            this.add(urlbar);
            this.add(tab_box);
            this.add(stack);
        }
    }
}
