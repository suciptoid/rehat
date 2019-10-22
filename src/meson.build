rehat_sources = [
  'application.vala',
  'window.vala',
  'widget/dropdown.vala',
  'widget/headerbar.vala',
  'widget/urlbar.vala',
  'widget/requestform.vala',
  'widget/headerinput.vala',
  'widget/request.vala',
  'widget/response.vala'
]

rehat_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('libsoup-2.4'),
  dependency('json-glib-1.0'),
  dependency('gtksourceview-4'),
]

gnome = import('gnome')

rehat_sources += gnome.compile_resources('rehat-resources',
  'rehat.gresource.xml',
  c_name: 'rehat'
)

executable('rehat', rehat_sources,
  vala_args: '--target-glib=2.50',  dependencies: rehat_deps,
  install: true,
)
