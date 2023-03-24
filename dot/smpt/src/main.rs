use std::{
    env::{args, current_dir},
    io::Error,
    path::Path,
    path::PathBuf,
};

use git2::Repository;

static RESET: &str = "\x1b[m";
static BOLD: &str = "\x1b[1m";
static YELLOW: &str = "\x1b[38;5;3m";
static RED: &str = "\x1b[38;5;9m";
static GREEN: &str = "\x1b[38;5;10m";
static BLUE: &str = "\x1b[38;5;12m";
static MAGENTA: &str = "\x1b[38;5;13m";
static CYAN: &str = "\x1b[38;5;14m";

fn main() -> Result<(), Error> {
    let args: Vec<String> = args().collect();
    let exit_status = match args.get(1) {
        Some(s) => matches!(s.as_str(), "0"),
        None => true,
    };
    let new_line = match args.get(2) {
        Some(s) => s.clone(),
        None => String::from("\n"),
    };

    let (repo_path, git_status) = {
        match Repository::discover(".") {
            Ok(repo) => {
                let repo_path = repo
                    .workdir()
                    .unwrap_or_else(|| Path::new(""))
                    .to_path_buf();
                match repo.head() {
                    Ok(head) => {
                        let head_oid = head.target().unwrap();
                        let branch = head.shorthand().unwrap().to_string();
                        let ahead_behind = repo
                            .revparse_ext("@{u}")
                            .ok()
                            .and_then(|(upstream, _)| {
                                repo.graph_ahead_behind(head_oid, upstream.id()).ok()
                            })
                            .map(|(ahead, behind)| {
                                format!(
                                    "{} {}",
                                    if ahead > 0 {
                                        format!("{RESET}{}{RED}⭫", little_number(ahead, "bottom"))
                                    } else {
                                        String::new()
                                    },
                                    if behind > 0 {
                                        format!("{RED}⭭{RESET}{}", little_number(behind, "top"))
                                    } else {
                                        String::new()
                                    }
                                )
                            })
                            .unwrap_or_default();
                        (
                            repo_path,
                            format!(
                                "⠶ {}{branch} {ahead_behind}",
                                match branch.as_str() {
                                    "main" => YELLOW,
                                    "develop" => MAGENTA,
                                    _ => CYAN,
                                }
                            ),
                        )
                    }
                    Err(_) => (repo_path, format!("⠶ {YELLOW}main")),
                }
            }
            Err(_) => (PathBuf::new(), String::new()),
        }
    };
    print!(
        "{RESET}{BLUE}{new_line}  {}{RESET} {git_status}{new_line} {}❱⟩{RESET} ",
        {
            let cwd = current_dir()?;
            let parent_path = match repo_path.parent() {
                Some(p) => p,
                None => cwd.parent().unwrap(),
            }
            .display()
            .to_string()
            .replace('\\', "/")
                + "/";
            cwd.display()
                .to_string()
                .replace('\\', "/")
                .replace(
                    parent_path.as_str(),
                    format!("{parent_path}{BOLD}").as_str(),
                )
                .replacen(
                    home::home_dir()
                        .unwrap_or_default()
                        .display()
                        .to_string()
                        .replace('\\', "/")
                        .as_str(),
                    "~",
                    1,
                )
        },
        if exit_status { GREEN } else { RED }
    );
    Ok(())
}

fn little_number(number: usize, position: &str) -> String {
    let mut r = String::new();
    for i in number.to_string().chars() {
        r.push_str(
            match position {
                "bottom" => "₀₁₂₃₄₅₆₇₈₉",
                "top" => "⁰¹²³⁴⁵⁶⁷⁸⁹",
                _ => panic!("Σ(･ω･ﾉ)ﾉ OMG!"),
            }
            .chars()
            .collect::<Vec<char>>()
            .get(i.to_string().parse::<usize>().unwrap())
            .unwrap()
            .to_string()
            .as_str(),
        )
    }
    r
}
