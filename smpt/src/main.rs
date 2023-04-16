mod run;

use std::env;

use crate::run::run;

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
