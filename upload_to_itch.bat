@echo off
setlocal
cd /d "%~dp0"

echo ===========================================
echo [CLEANING] ลบไฟล์ชั่วคราวและของเก่า...
echo ===========================================
.\.butler\butler.exe logout 2>nul
.\.butler\butler.exe login

echo.
echo ===========================================
echo [UPLOADING] กำลังส่งเกมไปยัง Itch.io...
echo ===========================================
:: ใช้ช่องทาง 'web' ซึ่งเป็นมาตรฐานสูงสุดสำหรับเบราว์เซอร์
.\.butler\butler.exe push docs thekaihuo/rpg:web

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] ส่งไฟล์ไม่สำเร็จ!
    pause
) else (
    echo.
    echo ===================================================
    echo [SUCCESS] ส่งไฟล์สำเร็จแล้ว!
    echo.
    echo ** ขั้นตอนสำคัญที่สุดบนหน้าเว็บ Itch.io **
    echo 1. ไปที่หน้า Edit Game
    echo 2. "ลบ" ไฟล์เก่าที่มีชื่อ .zip ออกให้หมด (จนช่อง Uploads ว่าง)
    echo 3. กดปุ่ม SAVE สีแดง
    echo 4. รอประมาณ 1 นาที แล้วรีเฟรชหน้าเว็บ
    echo 5. คุณจะเห็นไฟล์ใหม่ที่ Butler เพิ่งส่งไป (อาจจะชื่อ docs หรือ web)
    echo 6. ติ๊กช่อง 'This file will be played in the browser' ของไฟล์ใหม่
    echo 7. กด SAVE และลองรันอีกครั้งครับ
    echo ===================================================
)

pause
