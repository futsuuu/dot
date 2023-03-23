def create_left_prompt [] {
    ~/dev/github.com/futsuuu/dot/dot/smpt/target/release/smpt.exe $env.LAST_EXIT_CODE
}

let-env PROMPT_INDICATOR = { "" }
let-env PROMPT_INDICATOR_VI_INSERT = { "" }
let-env PROMPT_INDICATOR_VI_NORMAL = { "" }
let-env PROMPT_MULTILINE_INDICATOR = { "    " }
let-env PROMPT_COMMAND = { create_left_prompt }
