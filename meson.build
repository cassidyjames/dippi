project(
    'com.github.cassidyjames.dippi',
    'vala', 'c',
    version: '3.1.2'
)

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

asresources = gnome.compile_resources(
  'as-resources', 'data' / 'gresource.xml',
  source_dir: 'data',
  c_name: 'as'
)

executable(
  meson.project_name(),
  'src' / 'App.vala',
  'src' / 'MainWindow.vala',
  'src' / 'Utils.vala',
  asresources,
  dependencies: [
    dependency('glib-2.0'),
    dependency('granite', version: '>=6.0'),
    dependency('gtk+-3.0'),
    dependency('libhandy-1', version: '>=1.0.0'),
    meson.get_compiler('c').find_library('m', required : false)
  ],
  install: true
)
subdir('data')
subdir('po')

meson.add_install_script('meson'/ 'post_install.py')
