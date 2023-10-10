install_data(
  'icons' / meson.project_name() + '.svg',
  install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps',
)

install_data(
  'icons' / meson.project_name() + '-symbolic.svg',
  install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic' / 'apps',
)

i18n.merge_file(
  input: 'launcher.desktop.in',
  output: meson.project_name() + '.desktop',
  po_dir: meson.project_source_root() / 'po' / 'extra',
  type: 'desktop',
  install: true,
  install_dir: get_option('datadir') / 'applications'
)

i18n.merge_file(
  input: 'metainfo.appdata.xml.in',
  output: meson.project_name() + '.metainfo.xml',
  po_dir: meson.project_source_root() / 'po' / 'extra',
  type: 'xml',
  install: true,
  install_dir: get_option('datadir') / 'metainfo'
)

desktop_file_validate = find_program('desktop-file-validate', required:false)
if desktop_file_validate.found()
  test (
    'Validate desktop file',
    desktop_file_validate,
    args: meson.current_build_dir () / meson.project_name() + '.desktop'
  )
endif
