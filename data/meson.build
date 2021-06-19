icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        'icons' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: meson.project_name() + '.svg'
    )
    install_data(
        'icons' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: meson.project_name() + '.svg'
    )
endforeach

i18n.merge_file(
    input: 'launcher.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: meson.source_root() / 'po' / 'extra',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

i18n.merge_file(
    input: 'metadata.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    po_dir: meson.source_root() / 'po' / 'extra',
    type: 'xml',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)

# desktop_file_validate = find_program('desktop-file-validate', required:false)
# if desktop_file_validate.found()
#     test (
#         'Validate desktop file',
#         desktop_file_validate,
#         args: meson.current_build_dir () / meson.project_name() + '.desktop'
#     )
# endif

# appstreamcli = find_program(['appstreamcli', 'appstream-util'], required:false)
# if appstreamcli.found()
#     test (
#         'Validate appdata file',
#         appstreamcli,
#         args: ['validate', meson.current_build_dir () / meson.project_name() + '.appdata.xml']
#     )
# endif
