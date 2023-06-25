#![allow(dead_code)]

pub const RESET: &str = "\x1b[m";
pub const BOLD: &str = "\x1b[1m";

pub const BLACK: &str = "\x1b[38;5;0m";
pub const YELLOW: &str = "\x1b[38;5;3m";
pub const RED: &str = "\x1b[38;5;9m";
pub const GREEN: &str = "\x1b[38;5;10m";
pub const BLUE: &str = "\x1b[38;5;12m";
pub const MAGENTA: &str = "\x1b[38;5;13m";
pub const CYAN: &str = "\x1b[38;5;14m";

pub const YELLOW_BG: &str = "\x1b[48;5;3m";
pub const RED_BG: &str = "\x1b[48;5;9m";
pub const GREEN_BG: &str = "\x1b[48;5;10m";
pub const BLUE_BG: &str = "\x1b[48;5;12m";
pub const MAGENTA_BG: &str = "\x1b[48;5;13m";
pub const CYAN_BG: &str = "\x1b[48;5;14m";

pub fn small_number(number: usize, top: bool) -> String {
    let mut r = String::new();
    for i in number.to_string().chars() {
        r.push_str(
            if top {
                "⁰¹²³⁴⁵⁶⁷⁸⁹"
            } else {
                "₀₁₂₃₄₅₆₇₈₉"
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
