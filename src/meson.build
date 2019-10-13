rehat_sources = [
  'main.vala',
  'window.vala',
]

rehat_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
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
