project(
  'com.cassidyjames.dippi',
  'vala', 'c',
  version: '4.2.0',
  meson_version: '>=1.5.2',
)

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

asresources = gnome.compile_resources(
  'as-resources', 'data' / 'gresource.xml',
  source_dir: 'data',
  c_name: 'as'
)

config_data = configuration_data()

config_data.set_quoted('APP_ID', meson.project_name())
config_data.set_quoted('VERSION', meson.project_version())

config_file = configure_file(
  input: 'src/Config.vala.in',
  output: '@BASENAME@',
  configuration: config_data
)

executable(
  meson.project_name(),
  'src' / 'App.vala',
  'src' / 'MainWindow.vala',
  'src' / 'Utils.vala',
  asresources,
  config_file,
  dependencies: [
    dependency('gtk4', version: '>=4.19.4'),
    dependency('libadwaita-1', version: '>=1.8.1'),
    meson.get_compiler('c').find_library('m', required : false)
  ],
  install: true
)
subdir('data')
subdir('po')
