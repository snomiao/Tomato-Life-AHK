#SingleInstance, force
#Persistent
SetTimer ticker, 1000

global TomatoLife_LastStatus := ""
Menu, tray, icon, Tomato.ico

Return

UnixTimeStamp() {
    Static UnixStart := 116444736000000000
    DllCall("GetSystemTimeAsFileTime", "Int64P", FileTime)
    Return ((FileTime - UnixStart) // 10000) - 27 ; currently (2019-01-21) 27 leap seconds have been added
}
CheckTomato(){
    return Mod(UnixTimeStamp()/1000/60, 30) < 25 ? "工作" : "休息"
}
ticker:
    ; 对齐到下一分钟的 0 毫秒
    interval := 60000
    timeout := interval - Mod(UnixTimeStamp(), interval)
    SetTimer ticker, %timeout%
    
    TomatoLife_Status := CheckTomato()

    if(TomatoLife_LastStatus != TomatoLife_Status){
        TomatoLife_LastStatus := TomatoLife_Status
    }else{
        TomatoLife_Status := ""
    }
    if(TomatoLife_Status == "工作"){
        TrayTip, , 工作时间, 1
        ; Send #^{F4}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}
        Send #d
        try{
            Run %USERPROFILE%/.tomato-life/on_work.bat
            Run %USERPROFILE%/.tomato-life/on_work.vbs
        }
    }
    if(TomatoLife_Status == "休息"){
        TrayTip, , 休息时间, 1
        ; Send #^d
        Send #d
        try{
            Run %USERPROFILE%/.tomato-life/on_life.bat
            Run %USERPROFILE%/.tomato-life/on_life.vbs
        }
    }
return
