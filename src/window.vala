/* window.vala
 *
 * Copyright 2019 Sucipto
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
 */

namespace Rehat {
	public class Window : Gtk.ApplicationWindow {
	    string[] http_methods = {"GET","POST","DELETE","PATCH","PUT"};
        enum Column {
            METHOD
        }

		public Window (Gtk.Application app) {
			Object (application: app);
		}

		private Gtk.TextView textarea;

		construct {

		    // Header
		    var headerbar = new Gtk.HeaderBar();
            headerbar.show_close_button = true;
            headerbar.title = "Rehat! - REST Client";

            this.default_width = 1000;
            this.default_height = 500;
            this.window_position = Gtk.WindowPosition.CENTER;
		    this.set_titlebar(headerbar);

		    // Content Main
            var main_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
            this.add(main_box);

            // Sidebar
            var sidebar = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            //main_box.pack_start(sidebar);
            sidebar.add(new Gtk.Label("Sidebar"));

            // Content
            var content = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            main_box.pack_end(content);

            // Addressbar
            var url_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
            url_box.homogeneous = false;

            var method = new Gtk.ComboBox();
            var url_input = new Gtk.Entry();
            var send_btn = new Gtk.Button.with_label("Send");

            // Text Area
            textarea = new Gtk.TextView();
            textarea.set_wrap_mode(Gtk.WrapMode.WORD);
            textarea.margin = 8;

            url_input.margin = 8;
            url_input.hexpand = true;
            url_input.text = "https://api.github.com/users/showcheap";

            method.margin = 8;
            method.hexpand = false;
            send_btn.margin = 8;

            send_btn.get_style_context().add_class("suggested-action");

            var method_store = new Gtk.ListStore(1, typeof(string));
            for (int i = 0; i<http_methods.length; i++) {
                Gtk.TreeIter iter;
                method_store.append(out iter);
                method_store.set(iter, Column.METHOD, http_methods[i]);
            }

            method.model = method_store;
            method.set_active(0);

            var cell = new Gtk.CellRendererText();
            method.pack_start(cell,false);
            method.set_attributes(cell,"text",Column.METHOD);

            url_box.add(method);
            url_box.add(url_input);
            url_box.add(send_btn);

            content.add(url_box);
            content.pack_end(textarea);

            send_btn.clicked.connect(this.do_request);
		}

		private void do_request() {
		    var session = new Soup.Session();
		    var message = new Soup.Message("GET","https://api.github.com/users/showcheap");
		    var headers = new Soup.MessageHeaders(Soup.MessageHeadersType.REQUEST);
		    headers.append("User-Agent","Rehat");

		    message.request_headers = headers;

		    session.send_message(message);

		    //stdout.write(message.response_body.data);
		    var buffer = new Gtk.TextBuffer(null);
		    textarea.buffer = buffer;
		    buffer.text = (string) message.response_body.data;

		}
	}
}
