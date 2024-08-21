project(
  'com.github.cassidyjames.dippi',
  'vala', 'c',
  version: '4.1.1',
  meson_version: '>=1.3.2',
)

project_name = meson.project_name()

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (project_name), language:'c')

subdir('data')
subdir('src')
subdir('po')
