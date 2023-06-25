mod cwd;
mod git;
mod python;
mod utils;

use std::{env, io};

fn main() -> Result<(), std::io::Error> {
    let command_args = env::args().collect::<Vec<String>>();
    match &**command_args.get(1).unwrap() {
        "run" => run(
            command_args.get(2).unwrap(),
            command_args.get(3).unwrap_or(&"\n".to_string()),
        )?,
        "init" => {
            let smpt_command = command_args.get(0).unwrap();
            let shell = command_args.get(2).unwrap();
            let shell_script = match &**shell {
                "nu" => include_str!("shell/init.nu"),
                "bash" => include_str!("shell/init.bash"),
                _ => panic!("unknown shell: {shell}"),
            }
            .replace("::SMPT::", smpt_command);
            println!("{shell_script}")
        }
        _ => panic!("unknown command"),
    }
    Ok(())
}

fn run(exit_status: &str, new_line: &str) -> io::Result<()> {
    let exit_status = matches!(exit_status, "0");

    let git = git::Git::new()?;
    let python = python::Python::new();
    let cwd = cwd::Cwd::new(git.repo_path.parent())?;

    print!(
        "{reset}{new_line}  {cwd}{git}{python}{new_line} {prompt_color}❱⟩{reset} ",
        reset = utils::RESET,
        prompt_color = if exit_status {
            utils::GREEN
        } else {
            utils::RED
        }
    );
    Ok(())
}
