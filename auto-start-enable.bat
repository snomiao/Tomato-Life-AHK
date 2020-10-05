@echo off
chcp 65001

sudo.bat SCHTASKS /Create /SC ONLOGON /TN TomatoLife /TR "%~dp0TomatoLife.exe"
