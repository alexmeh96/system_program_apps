// #![feature(no_core)]
// #![feature(lang_items)]

#![no_std]
#![no_main]
// #![no_core]

// #[lang = "sized"]
// trait Sized {}

use core;

// стартовая функция
#[no_mangle]
pub extern "C" fn _start() -> ! {
    loop {}
}

// переопределение паники
#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}