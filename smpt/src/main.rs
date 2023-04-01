use std::{
    env::{args, current_dir},
    path::Path,
    path::PathBuf,
};

use git2::Repository;
use regex::Regex;

static RESET: &str = "\x1b[m";
static BOLD: &str = "\x1b[1m";
static YELLOW: &str = "\x1b[38;5;3m";
static RED: &str = "\x1b[38;5;9m";
static GREEN: &str = "\x1b[38;5;10m";
static BLUE: &str = "\x1b[38;5;12m";
static MAGENTA: &str = "\x1b[38;5;13m";
static CYAN: &str = "\x1b[38;5;14m";

fn main() {
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
                        let branch_name = head.shorthand().unwrap();
                        let ahead_behind = repo
                            .revparse_ext("@{u}")
                            .ok()
                            .and_then(|(upstream, _)| {
                                repo.graph_ahead_behind(head_oid, upstream.id()).ok()
                            })
                            .map(|(ahead, behind)| {
                                format!(
                                    "{}{}{}",
                                    if ahead > 0 {
                                        format!("{RESET}{}{RED}⭫", small_number(ahead, "bottom"))
                                    } else {
                                        String::new()
                                    },
                                    if (ahead > 0) & (behind > 0) { " " } else { "" },
                                    if behind > 0 {
                                        format!("{RED}⭭{RESET}{}", small_number(behind, "top"))
                                    } else {
                                        String::new()
                                    }
                                )
                            })
                            .unwrap_or_default();
                        (
                            repo_path,
                            format!("⠶ {} {ahead_behind}", highlight_branch(branch_name)),
                        )
                    }
                    Err(_) => (repo_path, format!("⠶ {}", highlight_branch("main"))),
                }
            }
            Err(_) => (PathBuf::new(), String::new()),
        }
    };
    print!(
        "{RESET}{BLUE}{new_line}  {}{RESET} {git_status}{new_line} {}❱⟩{RESET} ",
        {
            let cwd = match current_dir() {
                Ok(p) => p,
                Err(_) => panic!("Error: Cannot get current directory."),
            };
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
}

fn small_number(number: usize, position: &str) -> String {
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

fn highlight_branch(branch: &str) -> String {
    fn hl(branch: &str, re: &str, color: &str) -> Option<String> {
        let re = Regex::new(format!("(?i){re}").as_str()).unwrap();
        if re.is_match(branch) {
            Some(format!("{color}{branch}"))
        } else {
            None
        }
    }
    hl(branch, "^(main|master)$", YELLOW).unwrap_or(
        hl(branch, "^dev(elop|)$", MAGENTA)
            .unwrap_or(hl(branch, "^fix(/.*|)$", RED).unwrap_or(format!("{CYAN}{branch}"))),
    )
}