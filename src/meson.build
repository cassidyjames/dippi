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
  asresources,
  config_file,
  vala_args: [ '--gresourcesdir=data/' ],
  dependencies: [
    dependency ('appstream', version: '>=1.0.4'),
    dependency('gio-2.0', version: '>=2.80'),
    dependency('gio-unix-2.0', version: '>=2.80'),
    dependency('gtk4', version: '>=4.14.5'),
    dependency('libadwaita-1', version: '>=1.5.5'),
  ],
  install: true
)

