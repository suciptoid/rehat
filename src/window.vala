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
		private Soup.Session session;
		private Widget.UrlBar urlbar;

		private Widget.Request request;
		private Widget.Response response;

		private Gtk.Stack content_stack;

		public Window (Gtk.Application app) {
			Object (application: app);

			this.session = new Soup.Session();
			this.session.user_agent = "Rehat/1.0";
			this.session.timeout = 20;

		}

		construct {

		    // Header
		    var headerbar = new Widget.Header();
		    headerbar.title = "Rehat";

		    this.set_titlebar(headerbar);
		    headerbar.pack_end(new Gtk.Button.from_icon_name("open-menu-symbolic", Gtk.IconSize.BUTTON));
		    headerbar.pack_start(new Gtk.Button.from_icon_name("list-add-symbolic", Gtk.IconSize.BUTTON));

            urlbar = new Widget.UrlBar();
            urlbar.send.connect(() => {
                this.do_request();
            });

            // Window
            this.default_width = 1000;
            this.default_height = 500;
            this.window_position = Gtk.WindowPosition.CENTER;

		    // Content Main
		    var main_pane = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
		    //main_pane.wide_handle = true;
		    var content_pane = new Gtk.Paned(Gtk.Orientation.VERTICAL);
            var main_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);

            // Sidebar
            var sidebar = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            sidebar.add(new Gtk.Label("Sidebar"));
            sidebar.set_size_request(225,-1);

            main_pane.show.connect(() => {
                // TODO: hide until sidebar is usable
                sidebar.set_visible(false);
            });

            // Stack Content
            content_stack = new Gtk.Stack();

            // Tab Request
            request = new Widget.Request();

            // Tab Response
            response = new Widget.Response();

            this.add(main_pane);
            main_pane.add1(sidebar);

            content_pane.add1(request);
            content_pane.add2(response);

            var content_box = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            content_box.add(urlbar);
            content_box.add(content_pane);

            main_pane.add2(content_box);

            // Abort
            this.urlbar.stop.connect(() => {
                this.session.abort();
                this.urlbar.set_loading(false);
            });

		}

		private void do_request() {
            var url = urlbar.url;
            var method = urlbar.method;

            print("%s : %s\n", method, url);

            var message = urlbar.get_message();
            urlbar.set_loading(true);

            message.finished.connect(() => {
                print("Message finished\n");
                urlbar.set_loading(false);
            });

            // Headers
            var headers = request.get_headers();
            headers.foreach((k,v) => {
                message.request_headers.append(k,v);
            });

            // Body
            if (request.get_body() != null) {
                message.set_request(
                    request.request_body_type, // TODO: use from header form if defined Content-Type
                    Soup.MemoryUse.COPY,
                    request.get_body().data
                );
            }

            //message.request_headers = headers;
            this.session.queue_message(message, (ses,msg) => {
                var body = (string) msg.response_body.flatten().data;

		        msg.response_headers.foreach((name,val) => {
		            //print("%s: %s\n", name,val);
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

		        this.response.text.buffer = buffer;
            });
		}
	}
}
