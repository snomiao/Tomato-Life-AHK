sudo.bat SCHTASKS /Create /SC ONLOGON /TN TomatoLife /TR "%~dp0TomatoLife.exe"
SCHTASKS /Run /TN TomatoLife