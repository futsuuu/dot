use std::{
    env::current_dir,
    fs::File,
    io::{self, read_to_string},
    path::{Path, PathBuf},
};

use git2::Repository;
use home::home_dir;

static RESET: &str = "\x1b[m";
static BOLD: &str = "\x1b[1m";
static YELLOW: &str = "\x1b[38;5;3m";
static RED: &str = "\x1b[38;5;9m";
static GREEN: &str = "\x1b[38;5;10m";
static BLUE: &str = "\x1b[38;5;12m";
static MAGENTA: &str = "\x1b[38;5;13m";
static CYAN: &str = "\x1b[38;5;14m";

#[derive(Default)]
struct Git {
    repo_path: PathBuf,
    branch: String,
    ahead: usize,
    behind: usize,
}

impl Git {
    fn show_info(&self) -> String {
        let branch = if self.branch.is_empty() {
            return String::new();
        } else {
            self.branch.as_str()
        };

        let branch_prefix = match branch.splitn(2, '/').collect::<Vec<&str>>()[0] {
            "main" | "master" => {
                format!("{YELLOW} ")
            }
            "dev" | "develop" => {
                format!("{MAGENTA} ")
            }
            "feat" => {
                format!("{CYAN} ")
            }
            "fix" => {
                format!("{RED} ")
            }
            "release" => {
                format!("{GREEN} ")
            }
            _ => format!("{CYAN} "),
        };

        let ahead = if self.ahead == 0 {
            String::new()
        } else {
            format!(" {RESET}{}{RED}⭫", small_number(self.ahead, "bottom"))
        };

        let behind = if self.behind == 0 {
            String::new()
        } else {
            format!(" {RED}⭭{RESET}{}", small_number(self.behind, "top"))
        };

        format!("⠶ {branch_prefix}{branch}{ahead}{behind}")
    }
}

pub fn run(exit_status: &str, new_line: &str) -> io::Result<()> {
    let exit_status = matches!(exit_status, "0");

    let git = {
        match Repository::discover(".") {
            Err(_) => Git::default(),
            Ok(repo) => {
                let repo_path = repo.workdir().unwrap_or_else(|| repo.path()).to_path_buf();
                let head_ref = read_to_string(File::open(repo.path().join("HEAD"))?)?;

                let branch = if head_ref.starts_with("ref: refs/heads/") {
                    head_ref.trim_start_matches("ref: refs/heads/")
                } else {
                    head_ref.get(..7).unwrap()
                }
                .trim()
                .to_string();

                match repo.head() {
                    Ok(head) => {
                        let head_oid = head.target().unwrap();
                        let (ahead, behind) = repo
                            .revparse_ext("@{upstream}")
                            .ok()
                            .and_then(|(upstream, _)| {
                                repo.graph_ahead_behind(head_oid, upstream.id()).ok()
                            })
                            .unwrap_or_default();
                        Git {
                            repo_path,
                            branch,
                            ahead,
                            behind,
                        }
                    }
                    Err(_) => Git {
                        repo_path,
                        ahead: 0,
                        behind: 0,
                        branch,
                    },
                }
            }
        }
    };
    print!(
        "{RESET}{BLUE}{new_line}   {}{RESET} {}{new_line} {}❱⟩{RESET} ",
        {
            let cwd = current_dir()?;
            let parent_path = match git.repo_path.parent() {
                Some(p) => p,
                None => cwd.parent().unwrap_or(Path::new("/")),
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
                    home_dir()
                        .unwrap_or_default()
                        .display()
                        .to_string()
                        .replace('\\', "/")
                        .as_str(),
                    "~",
                    1,
                )
        },
        git.show_info(),
        if exit_status { GREEN } else { RED }
    );
    Ok(())
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
