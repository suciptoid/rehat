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
        construct {
            var vbox_pop = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
            vbox_pop.margin = 4;

            // Stack
            var stack = new Gtk.Stack();
            var stack_switcher = new Gtk.StackSwitcher();
            stack_switcher.stack = stack;

            stack.add_titled(new Gtk.Label("Stack1"), "body", "Body");
            stack.add_titled(new Gtk.Label("Stack2"), "headers", "Headers");

            vbox_pop.add(stack_switcher);
            vbox_pop.add(stack);

            this.add(vbox_pop);
            this.position = Gtk.PositionType.BOTTOM;
            this.modal = false;
        }
    }
}
