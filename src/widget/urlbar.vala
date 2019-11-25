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
        Gtk.Button stop_button;
        Widget.DropDown method_dropdown;

        // Signals
        public signal void send();
        public signal void stop();

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
            url_entry.text = "http://localhost:3000";
            url_entry.placeholder_text = "http://example.com/api";
            url_entry.changed.connect(() => {
                this.url = url_entry.text;
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

            // Stop Button
            stop_button = new Gtk.Button.with_label("Stop");
            stop_button.get_style_context().add_class("destructive-action"); // Make it blue
            stop_button.clicked.connect(() => {
                this.stop();
            });

            this.margin = 8;
            this.add(method_dropdown);
            this.add(url_entry);
            this.add(send_button);
            this.add(stop_button);

            this.show.connect(() => {
                stop_button.set_visible(false);
            });

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

        public void set_loading(bool loading) {
            if (loading) {
                stop_button.set_visible(true);
                send_button.set_visible(false);
            } else {
                send_button.set_visible(true);
                stop_button.set_visible(false);
            }
        }

    }
}
