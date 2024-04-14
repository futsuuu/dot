use std::{sync::Mutex, thread, time::Duration};

use once_cell::sync::Lazy;
use serde_json::{json, Value};
use sysinfo::System;

pub static DATA: Lazy<Mutex<Value>> = Lazy::new(|| {
    Mutex::new(json!({
        "memory": 0,
        "cpu": 0,
        "battery": 0,
    }))
});

static SYSTEM: Lazy<Mutex<System>> = Lazy::new(|| Mutex::new(System::new()));

pub fn start() {
    thread::spawn(move || loop {
        thread::sleep(Duration::from_secs(2));

        let mut s = SYSTEM.lock().unwrap();
        s.refresh_memory();

        let total = s.total_memory();
        let available = s.available_memory();

        let per = (((total - available) as f64 / total as f64) * 100.0) as u16;

        DATA.lock().unwrap()["memory"] = per.into();
    });

    thread::spawn(move || loop {
        thread::sleep(Duration::from_millis(750));

        let mut s = SYSTEM.lock().unwrap();
        s.refresh_cpu();

        let per = s.global_cpu_info().cpu_usage() as u16;

        DATA.lock().unwrap()["cpu"] = per.into();
    });

    thread::spawn(move || loop {
        let manager = starship_battery::Manager::new().unwrap();
        if let Some(battery) = manager.batteries().unwrap().next() {
            let state = format!("{:?}", battery.unwrap().state_of_charge());

            let per = (state.parse::<f64>().unwrap() * 100.0) as u16;

            DATA.lock().unwrap()["battery"] = per.into();
        }

        thread::sleep(Duration::from_secs(20));
    });
}
