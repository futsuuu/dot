def create_left_prompt [] {
    ~/dev/github.com/futsuuu/dot/dot/smpt/target/release/smpt $env.LAST_EXIT_CODE
}

def create_right_prompt [] {
}

let-env PROMPT_INDICATOR = { "" }
let-env PROMPT_INDICATOR_VI_INSERT = { "" }
let-env PROMPT_INDICATOR_VI_NORMAL = { "" }
let-env PROMPT_MULTILINE_INDICATOR = { "    " }
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }
