export-env { $env.config.color_config = {
  # color for nushell primitives
  separator: dark_gray
  leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
  header: white_bold
  empty: blue
  # Closures can be used to choose colors for specific values.
  # The value (in this case, a bool) is piped into the closure.
  bool: yellow
  filesize: {|e|
    if $e == 0b {
      'white'
    } else if $e < 1mb {
      'cyan'
    } else { 'blue' }
  }
  duration: white
  date: { || (date now) - $in |
    if $in < 1hr {
      '#e61919'
    } else if $in < 6hr {
      '#e68019'
    } else if $in < 1day {
      '#e5e619'
    } else if $in < 3day {
      '#80e619'
    } else if $in < 1wk {
      '#19e619'
    } else if $in < 6wk {
      '#19e5e6'
    } else if $in < 52wk {
      '#197fe6'
    } else { 'light_gray' }
  }
  range: white
  float: yellow
  int: yellow
  string: green
  nothing: white
  binary: { fg: red, attr: b }
  cellpath: white
  row_index: dark_gray
  record: purple
  list: cyan
  block: white
  hints: { fg: dark_gray, attr: i }

  shape_and: purple_bold
  shape_binary: purple_bold
  shape_block: blue_bold
  shape_bool: yellow
  shape_custom: green
  shape_datetime: cyan_bold
  shape_external: cyan
  shape_externalarg: green
  shape_filepath: green
  shape_directory: green
  shape_flag: white
  shape_float: yellow
  shape_int: yellow
  # shapes are used to change the cli syntax highlighting
  shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b }
  shape_globpattern: cyan_bold
  shape_internalcall: cyan_bold
  shape_list: cyan_bold
  shape_literal: blue
  shape_matching_brackets: { attr: u }
  shape_nothing: light_cyan
  shape_operator: purple
  shape_or: purple
  shape_pipe: purple
  shape_range: cyan
  shape_record: cyan_bold
  shape_redirection: purple_bold
  shape_signature: green_bold
  shape_string: green
  shape_string_interpolation: cyan_bold
  shape_table: blue_bold
  shape_variable: purple
} }
