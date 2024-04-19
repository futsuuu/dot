use std::{
    sync::{Arc, Mutex},
    thread::{sleep, spawn},
    time::Duration,
};

use serde::Serialize;
use sysinfo::System;

#[derive(Default, Serialize)]
struct Info {
    date: DateInfo,
    sys: SysInfo,
}

#[derive(Default, Serialize)]
struct DateInfo {
    hour: String,
    minute: String,
}

#[derive(Default, Serialize)]
struct SysInfo {
    memory: u16,
    cpu: u16,
    battery: u16,
}

fn main() {
    let i = Arc::new(Mutex::new(Info::default()));
    let s = Arc::new(Mutex::new(System::new()));

    let info = i.clone();
    spawn(move || loop {
        let now = chrono::Local::now();
        info.lock().unwrap().date = DateInfo {
            hour: now.format("%H").to_string(),
            minute: now.format("%M").to_string(),
        };
        sleep(Duration::from_secs(1));
    });

    let (info, system) = (i.clone(), s.clone());
    spawn(move || loop {
        let mut s = system.lock().unwrap();
        s.refresh_memory();

        let total = s.total_memory();
        let available = s.available_memory();

        let per = (((total - available) as f64 / total as f64) * 100.0) as u16;
        info.lock().unwrap().sys.memory = per.into();

        drop(s);
        sleep(Duration::from_secs(2));
    });

    let (info, system) = (i.clone(), s.clone());
    spawn(move || loop {
        let mut s = system.lock().unwrap();
        s.refresh_cpu();
        let per = s.global_cpu_info().cpu_usage() as u16;
        info.lock().unwrap().sys.cpu = per.into();

        drop(s);
        sleep(Duration::from_millis(750));
    });

    let info = i.clone();
    spawn(move || loop {
        let manager = starship_battery::Manager::new().unwrap();
        if let Some(battery) = manager.batteries().unwrap().next() {
            let state = format!("{:?}", battery.unwrap().state_of_charge());

            let per = (state.parse::<f64>().unwrap() * 100.0) as u16;
            info.lock().unwrap().sys.battery = per.into();
        }
        sleep(Duration::from_secs(20));
    });

    let info = i.clone();
    loop {
        sleep(Duration::from_millis(250));
        println!("{}", serde_json::to_string(&*info.lock().unwrap()).unwrap());
    }
}
