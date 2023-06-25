use std::{fmt::Display, fs::read_to_string, io, path::PathBuf};

use git2::Repository;

use crate::utils;

#[derive(Default)]
pub struct Git {
    pub repo_path: PathBuf,
    pub branch: String,
    pub ahead: usize,
    pub behind: usize,
}

impl Display for Git {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let branch = if self.branch.is_empty() {
            return Ok(());
        } else {
            self.branch.as_str()
        };

        let branch_prefix = match branch.splitn(2, '/').collect::<Vec<&str>>()[0] {
            "src" | "main" | "master" => {
                format!("{} ", utils::YELLOW)
            }
            "dev" | "develop" => {
                format!("{} ", utils::MAGENTA)
            }
            "feat" => {
                format!("{} ", utils::CYAN)
            }
            "fix" => {
                format!("{} ", utils::RED)
            }
            "release" => {
                format!("{} ", utils::GREEN)
            }
            _ => format!("{} ", utils::CYAN),
        };

        let ahead = if self.ahead == 0 {
            String::new()
        } else {
            format!(
                "{}{}{}⭫",
                utils::RESET,
                utils::small_number(self.ahead, false),
                utils::RED
            )
        };

        let behind = if self.behind == 0 {
            String::new()
        } else {
            format!(
                "{}⭭{}{}",
                utils::RED,
                utils::small_number(self.behind, true),
                utils::RESET
            )
        };

        write!(
            f,
            "{} ⠶ {branch_prefix}{branch}{}{ahead}{behind}",
            utils::RESET,
            if self.ahead == 0 && self.behind == 0 {
                ""
            } else {
                " "
            }
        )
    }
}

impl Git {
    pub fn new() -> io::Result<Self> {
        let Ok(repo) = Repository::discover(".") else {
            return Ok(Git::default());
        };

        let repo_path = repo.workdir().unwrap_or_else(|| repo.path()).to_path_buf();
        let head_ref = read_to_string(repo.path().join("HEAD"))?;

        let branch = if head_ref.starts_with("ref: refs/heads/") {
            head_ref.trim_start_matches("ref: refs/heads/")
        } else {
            head_ref.get(..7).unwrap()
        }
        .trim()
        .to_string();

        let git = match repo.head() {
            Ok(head) => {
                let head_oid = head.target().unwrap();
                let (ahead, behind) = repo
                    .revparse_ext("@{upstream}")
                    .ok()
                    .and_then(|(upstream, _)| repo.graph_ahead_behind(head_oid, upstream.id()).ok())
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
        };

        Ok(git)
    }
}
