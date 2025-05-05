@echo off

"C:\Users\PC\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.9.dev3/esptool.exe" --chip esp32s3 --baud 921600  --before default_reset --after hard_reset write_flash  -z --flash_mode keep --flash_freq keep --flash_size keep 0x0 "C:\Users\PC\AppData\Local\arduino\sketches\08E9F777368F14E19D66A93109221BDC/CameraWebServer_for_esp-arduino_3.0.x.ino.bootloader.bin" 0x8000 "C:\Users\PC\AppData\Local\arduino\sketches\08E9F777368F14E19D66A93109221BDC/CameraWebServer_for_esp-arduino_3.0.x.ino.partitions.bin" 0xe000 "C:\Users\PC\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.1.3/tools/partitions/boot_app0.bin" 0x10000 "C:\Users\PC\AppData\Local\arduino\sketches\08E9F777368F14E19D66A93109221BDC/CameraWebServer_for_esp-arduino_3.0.x.ino.bin" 

pause