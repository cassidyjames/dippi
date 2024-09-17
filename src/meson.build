config_data = configuration_data()

config_data.set_quoted('APP_ID', meson.project_name())
config_data.set_quoted('VERSION', meson.project_version())

config_file = configure_file(
  input: 'Config.vala.in',
  output: '@BASENAME@',
  configuration: config_data
)

executable(
  meson.project_name(),
  'App.vala',
  'MainWindow.vala',
  'NewWindow.vala',
  'Utils.vala',
  asresources,
  config_file,
  vala_args: [ '--gresourcesdir=data/' ],
  dependencies: [
    dependency('gtk4', version: '>=4.14.4'),
    dependency('libadwaita-1', version: '>=1.5.3'),
    meson.get_compiler('c').find_library('m', required : false)
  ],
  install: true
)

