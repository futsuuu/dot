export-env {

export module config/color_config.nu
export module config/keybindings.nu
export module config/hooks.nu

use color_config
use keybindings
use hooks

# External completer example
# let carapace_completer = {|spans|
#     carapace $spans.0 nushell $spans | from json
# }

$env.config = ($env.config | merge {
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: false # always act as if -t was given. Can be overridden with -p
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    header_on_separator: true
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "… " # A suffix used by the 'truncating' methodology
    }
  }

  explore: {
    help_banner: true
    exit_esc: true

    command_bar_text: '#C4C9C6'
    # command_bar: {fg: '#C4C9C6' bg: '#223311' }

    status_bar_background: { fg: '#1D1F21' bg: '#C4C9C6' }
    # status_bar_text: {fg: '#C4C9C6' bg: '#223311' }

    highlight: { bg: 'yellow' fg: 'black' }

    status: {
      # warn: {bg: 'yellow', fg: 'blue'}
      # error: {bg: 'yellow', fg: 'blue'}
      # info: {bg: 'yellow', fg: 'blue'}
    }

    try: {
      # border_color: 'red'
      # highlighted_color: 'blue'

      # reactive: false
    }

    table: {
      split_line: '#404040'

      cursor: true

      line_index: true
      line_shift: true
      line_head_top: true
      line_head_bottom: true

      show_head: true
      show_index: true

      # selected_cell: {fg: 'white', bg: '#777777'}
      # selected_row: {fg: 'yellow', bg: '#C1C2A3'}
      # selected_column: blue

      # padding_column_right: 2
      # padding_column_left: 2

      # padding_index_left: 2
      # padding_index_right: 1
    }

    config: {
      cursor_color: { bg: 'yellow' fg: 'black' }

      # border_color: white
      # list_color: green
    }
  }

  history: {
    max_size: 10000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "plaintext" # "sqlite" or "plaintext"
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "fuzzy"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
  }
  filesize: {
    unit: metric
  }
  footer_mode: auto # always, never, number_of_rows, auto
  float_precision: 2
  use_ansi_coloring: true
  edit_mode: vi # emacs, vi
  shell_integration: {} # enables terminal markers and a workaround to arrow keys stop working issue
  show_banner: false
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.

  menus: [
    # Configuration for default nushell menus
    # Note the lack of source parameter
    {
      name: completion_menu
      only_buffer_difference: false
      marker: ""
      type: {
        layout: columnar
        columns: 4
        col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: ""
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: ""
      type: {
        layout: description
        columns: 4
        col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
    }
    # Example of extra menus created using a nushell source
    # Use the source field to create a list of records that populates
    # the menu
    {
      name: commands_menu
      only_buffer_difference: false
      marker: ""
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        $nu.scope.commands
        | where name =~ $buffer
        | each { |it| { value: $it.name description: $it.usage } }
      }
    }
    {
      name: vars_menu
      only_buffer_difference: true
      marker: ""
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        $nu.scope.vars
        | where name =~ $buffer
        | sort-by name
        | each { |it| { value: $it.name description: $it.type } }
      }
    }
    {
      name: commands_with_description
      only_buffer_difference: true
      marker: ""
      type: {
        layout: description
        columns: 4
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: green
        selected_text: green_reverse
        description_text: yellow
      }
      source: { |buffer, position|
        $nu.scope.commands
        | where name =~ $buffer
        | each { |it| { value: $it.name description: $it.usage } }
      }
    }
  ]
})

}
