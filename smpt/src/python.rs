use std::{env, fmt::Display};

use crate::utils;

pub struct Python {
    venv_name: Option<String>,
}

impl Display for Python {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let Some(venv_name) = &self.venv_name else {
            return Ok(());
        };
        write!(
            f,
            "{reset} {yellow_fg}{black_bg}{bg} {}{reset}{yellow_fg}",
            venv_name.trim(),
            bg = utils::YELLOW_BG,
            black_bg = utils::BLACK,
            yellow_fg = utils::YELLOW,
            reset = utils::RESET,
        )
    }
}

impl Python {
    pub fn new() -> Self {
        Self {
            venv_name: env::var("VIRTUAL_ENV_PROMPT").ok(),
        }
    }
}
