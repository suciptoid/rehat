/* urlbar.vala
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
    public class UrlBar : Gtk.Box {
        Gtk.Entry url_entry;
        Gtk.Button send_button;
        Gtk.ToggleButton pop_button;
        Widget.DropDown method_dropdown;
        Widget.RequestForm popover;

        // Signals
        public signal void send();

        // Properties
        public string method { get; set; }
        public string url { get; set; }
        public string body { get; set; }
        public string headers { get; set; }

        public UrlBar() {
            Object(
                orientation: Gtk.Orientation.HORIZONTAL,
                spacing: 0
            );
        }

        construct {
            this.homogeneous = false;

            // URL Entry
            url_entry = new Gtk.Entry();
            url_entry.hexpand = true;
            url_entry.text = "https://api.github.com/users/showcheap";
            //url_entry.margin_end = 4;
            //url_entry.margin_start = 4;
            url_entry.placeholder_text = "http://example.com/api";
            url_entry.changed.connect(() => {
                print("URL Entry changed %s\n", url_entry.text);
                this.url = url_entry.text;
            });

            // Request Pop Button
            pop_button = new Gtk.ToggleButton();//.from_icon_name("open-menu-symbolic");
            pop_button.add(new Gtk.Image.from_icon_name("open-menu-symbolic", Gtk.IconSize.BUTTON));
            pop_button.margin_start = 4;
            pop_button.clicked.connect(() => {
                if(pop_button.active) {
                    popover.show_all();
                    popover.popup();
                    return;
                }
                popover.popdown();
            });

            // Popover menu
            popover = new Widget.RequestForm();
            popover.set_relative_to(pop_button);
            popover.closed.connect(() => {
                print("Popover closed\n");
                pop_button.active = false;
            });

            // HTTP Method Dropdown
            method_dropdown = new Widget.DropDown();
            method_dropdown.set_active(0);
            method_dropdown.changed.connect(() => {
                this.method = method_dropdown.get_method();
            });

            // Send Button
            send_button = new Gtk.Button.with_label("Send");
            send_button.get_style_context().add_class("suggested-action"); // Make it blue
            send_button.clicked.connect(this.on_send_click);

            this.margin = 8;
            this.add(method_dropdown);
            //this.add(pop_button);
            this.add(url_entry);
            this.add(send_button);

            this.url = url_entry.text;
            this.method = method_dropdown.get_method();
            this.get_style_context().add_class("linked");
        }

        private void on_send_click() {
            this.send();
        }

        public Soup.Message get_message() {
            var message = new Soup.Message(this.method, this.url);

            return message;
        }

    }
}
