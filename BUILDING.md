## Install Dependency
First we need to make sure we have all needed dependency as follow:
- Meson Build System
- Vala
- GTK 3
- Soup
- Json GLib
- GTK Source View 4

If you're running Fedora, you can use following command to install all needed dependency:
```
$ dnf install meson vala gtk3-devel libsoup-devel json-glib-devel gtksourceview4-devel`
```

## Start Building
After you finish setting up all needed dependency, we can go forward with building process.
Simply run:

```
$ meson build
The Meson build system
Version: 0.51.2
Source dir: /<path>/rehat
Build dir: /<path>/rehat/build
Build type: native build
Project name: rehat
Project version: 0.1.0
C compiler for the host machine: ccache cc (gcc 9.2.1 "cc (GCC) 9.2.1 20190827 (Red Hat 9.2.1-1)")
Vala compiler for the host machine: valac (valac 0.46.3)
Build machine cpu family: x86_64
Build machine cpu: x86_64
Program desktop-file-validate found: YES (/usr/bin/desktop-file-validate)
Program appstream-util found: YES (/usr/bin/appstream-util)
Program glib-compile-schemas found: YES (/usr/bin/glib-compile-schemas)
Found pkg-config: /usr/bin/pkg-config (1.6.3)
Run-time dependency gio-2.0 found: YES 2.62.1
Run-time dependency gtk+-3.0 found: YES 3.24.12
Run-time dependency libsoup-2.4 found: YES 2.68.2
Run-time dependency json-glib-1.0 found: YES 1.4.4
Run-time dependency gtksourceview-4 found: YES 4.4.0
Found pkg-config: /usr/bin/pkg-config (1.6.3)
Program build-aux/meson/postinstall.py found: YES (/<path>/rehat/build-aux/meson/postinstall.py)
Build targets in project: 8
Found ninja-1.9.0 at /usr/bin/ninja
```

If Meson didn't throw error while runing the build script, we can now enter the build directory and start `ninja` build system
```
$ cd build
$ ninja
```

After compilation process done, and no error occured. You can execute `rehat` on `src` directory
```
$ src/rehat
```
