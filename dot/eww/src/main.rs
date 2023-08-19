mod date;
mod sys;

use std::{thread, time::Duration};

use serde_json::json;

fn main() {
    date::start();
    sys::start();

    loop {
        thread::sleep(Duration::from_millis(250));

        let out = json!({
            "date": *date::DATA.lock().unwrap(),
            "sys": *sys::DATA.lock().unwrap(),
        });

        println!("{out}");
    }
}
