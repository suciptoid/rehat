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

		private Gtk.SourceView textarea;
		private Gtk.Entry url_input;
		private Widget.DropDown method;
		private Soup.Session session;

		public Window (Gtk.Application app) {
			Object (application: app);

			this.session = new Soup.Session();
			this.session.user_agent = "Rehat/1.0";

		}

		construct {

		    // Header
		    var headerbar = new Widget.Header();
		    this.set_titlebar(headerbar);

            // Window
            this.default_width = 1000;
            this.default_height = 500;
            this.window_position = Gtk.WindowPosition.CENTER;

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

            method = new Widget.DropDown();
            method.set_active(0);
            method.margin = 8;
            method.hexpand = false;

            url_input = new Gtk.Entry();
            var send_btn = new Gtk.Button.with_label("Send");

            // Text Area
            textarea = new Gtk.SourceView();
            textarea.set_wrap_mode(Gtk.WrapMode.WORD);
            textarea.auto_indent = true;
            textarea.highlight_current_line = false;
            textarea.editable = false;

            var text_scrollbar = new Gtk.ScrolledWindow(null, null);
            text_scrollbar.margin = 8;
            text_scrollbar.add(textarea);

            url_input.margin = 8;
            url_input.hexpand = true;
            url_input.text = "https://api.github.com/users/showcheap";

            send_btn.margin = 8;
            send_btn.get_style_context().add_class("suggested-action");
            send_btn.clicked.connect(this.do_request);

            url_box.add(method);
            url_box.add(url_input);
            url_box.add(send_btn);

            content.add(url_box);
            content.pack_end(text_scrollbar);
		}

		private void do_request() {
            var url = url_input.buffer.get_text();
            var method = this.method.get_method();

            print("%s : %s\n", method, url);

            var message = new Soup.Message(method,url);

            this.session.queue_message(message, (ses,msg) => {
                var body = (string) msg.response_body.flatten().data;
                print("Response\n%s\n",body);


                print("Headers:\n");
		        msg.response_headers.foreach((name,val) => {
		            print("%s: %s\n", name,val);
		        });

                var lang_mgr = new Gtk.SourceLanguageManager();
                HashTable ct;
                var content_type = msg.response_headers.get_content_type(out ct);

                //print("Content type: %s\n", content_type);
                var lang = lang_mgr.guess_language(null,content_type);

                var buffer = new Gtk.SourceBuffer.with_language(lang);
                buffer.highlight_syntax = true;
		        textarea.buffer = buffer;

		        // Textarea Color Scheme
		        var scheme_mgr = new Gtk.SourceStyleSchemeManager();

		        buffer.style_scheme = scheme_mgr.get_scheme("kate");

                if (content_type == "application/json") {
		            // Parse & Format JSON
		            var parser = new Json.Parser();
		            var generator = new Json.Generator();

                    try {
		                parser.load_from_data(body);
                    } catch (Error e) {
                        print("JSON Generator error load data: %s\n", e.message);
                    }

		            generator.set_root(parser.get_root());
		            generator.pretty = true;
		            generator.indent = 4;

		            var formatted = generator.to_data(null);

		            print(formatted);
		            buffer.text = formatted;
		        } else {
		            buffer.text = body;
		        }
            });
		}
	}
}
