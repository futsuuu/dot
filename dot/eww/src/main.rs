mod date;
mod sys;

use std::{env, error::Error, thread, time::Duration};

use serde_json::json;
use sysinfo::{CpuExt, CpuRefreshKind, RefreshKind, System, SystemExt};

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
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

    match args[1].as_str() {
        "memory" => {
            let s = System::new_with_specifics(RefreshKind::new().with_memory());
            let total = s.total_memory();
            let available = s.available_memory();
            println!(
                "{}",
                (((total - available) as f64 / total as f64) * 100.0) as u16
            )
        }
        "cpu" => {
            let s = System::new_with_specifics(
                RefreshKind::new().with_cpu(CpuRefreshKind::new().with_cpu_usage()),
            );
            println!("{}", s.global_cpu_info().cpu_usage() as u16)
        }
        "battery" => {
            let manager = battery::Manager::new()?;
            for battery in manager.batteries()? {
                let state = format!("{:?}", battery?.state_of_charge());
                let f: f64 = state.parse()?;
                println!("{}", (f * 100.0) as u16)
            }
        }
        _ => (),
    }

    Ok(())
}
