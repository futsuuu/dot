use std::{sync::Mutex, thread, time::Duration};

use once_cell::sync::Lazy;
use serde_json::{json, Value};

pub static DATA: Lazy<Mutex<Value>> = Lazy::new(|| Mutex::new(json!({})));

pub fn start() {
    thread::spawn(move || loop {
        let now = chrono::Local::now();
        let hour = format!("{}", now.format("%H"));
        let minute = format!("{}", now.format("%M"));

        let json = json!({
            "hour": hour,
            "minute": minute,
        });
        *DATA.lock().unwrap() = json;

        thread::sleep(Duration::from_secs(1));
    });
}
