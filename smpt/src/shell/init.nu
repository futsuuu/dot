let-env PROMPT_INDICATOR = ""
let-env PROMPT_INDICATOR_VI_INSERT = ""
let-env PROMPT_INDICATOR_VI_NORMAL = ""
let-env PROMPT_MULTILINE_INDICATOR = "    " 
let-env PROMPT_COMMAND = { || ^::SMPT:: run $env.LAST_EXIT_CODE  } 
let-env PROMPT_COMMAND_RIGHT = ""