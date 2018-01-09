project('com.github.cassidyjames.dippi', 'vala', 'c')

gnome = import('gnome')

executable(
    meson.project_name(),
    'src/dippi.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gtk+-3.0'),
        meson.get_compiler('c').find_library('m', required : false)
    ],
    install: true
)
subdir('data')

