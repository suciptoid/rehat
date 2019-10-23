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

		}

		construct {

		    // Header
		    var headerbar = new Widget.Header();
		    this.set_titlebar(headerbar);
		    headerbar.pack_end(new Gtk.Button.from_icon_name("open-menu-symbolic", Gtk.IconSize.BUTTON));
		    headerbar.pack_start(new Gtk.Button.from_icon_name("list-add-symbolic", Gtk.IconSize.BUTTON));

		    // Req/Res Tab switcher
		    var tab_switch = new Gtk.StackSwitcher();
		    headerbar.custom_title = tab_switch;

            // Window
            this.default_width = 1000;
            this.default_height = 500;
            this.window_position = Gtk.WindowPosition.CENTER;

		    // Content Main
		    var main_pane = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
            var main_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);

            // Sidebar
            var sidebar = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            sidebar.add(new Gtk.Label("Sidebar"));
            sidebar.set_size_request(300,-1);

            // Stack Content
            content_stack = new Gtk.Stack();
            tab_switch.stack = content_stack;

            // Tab Request
            request = new Widget.Request();
            content_stack.add_titled(request,"request","Request");

            // Tab Response
            response = new Widget.Response();
            content_stack.add_titled(response,"response","Response");


            // Text Area
            //textarea = new Gtk.SourceView();
            //textarea.set_wrap_mode(Gtk.WrapMode.WORD);
            //textarea.auto_indent = true;
            //textarea.highlight_current_line = false;
            //textarea.editable = false;

            //var text_scrollbar = new Gtk.ScrolledWindow(null, null);
            //text_scrollbar.margin = 8;
            //text_scrollbar.add(textarea);

            //urlbar = new Widget.UrlBar();
            request.urlbar.send.connect(() => {
                this.do_request();
            });

            this.add(main_pane);
            main_pane.add1(sidebar);
            main_pane.add2(main_box);
            main_box.pack_end(content_stack);
		}

		private void do_request() {
            var url = request.urlbar.url;
            var method = request.urlbar.method;

            print("%s : %s\n", method, url);

            var message = request.urlbar.get_message();//new Soup.Message(method,url);
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
