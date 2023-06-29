use std::{env, fmt::Display, io, path::Path};

use home::home_dir;

use crate::utils;

pub struct Cwd {
    path: String,
    parent: String,
}

impl Display for Cwd {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let a = self
            .path
            .replace('\\', "/")
            .replace(
                self.parent.as_str(),
                format!("{}{}", self.parent, utils::BOLD).as_str(),
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
            );
        write!(f, "{} {}", utils::BLUE, a)
    }
}

impl Cwd {
    pub fn new(parent: Option<&Path>) -> io::Result<Cwd> {
        let cwd = env::current_dir()?;
        let parent_path = match parent {
            Some(p) => p,
            None => cwd.parent().unwrap_or(Path::new("/")),
        }
        .display()
        .to_string()
        .replace('\\', "/")
            + "/";
        Ok(Self {
            path: cwd.display().to_string(),
            parent: parent_path,
        })
    }
}
