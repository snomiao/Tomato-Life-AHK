#SingleInstance, force
#Persistent
; ToolTip, % UnixTimeStamp()
; Sleep, 1000
SetTimer ticker, 1000
; SetTimer, Label [, Period|On|Off]

global TomatoLife_LastStatus := ""
Return

UnixTimeStamp() {
    Static UnixStart := 116444736000000000
    DllCall("GetSystemTimeAsFileTime", "Int64P", FileTime)
    Return ((FileTime - UnixStart) // 10000) - 27 ; currently (2019-01-21) 27 leap seconds have been added
}
CheckTomato(t){
    UnixTimeStamp()
}
ticker:
    timeout := 1000 - Mod(UnixTimeStamp(), 1000) ; 对齐到下一秒的 0 毫秒
    SetTimer ticker, %timeout%
    
    TomatoLife_Status := Mod(UnixTimeStamp()/1000/60, 30) < 25 ? "工作" : "休息"

    if(TomatoLife_LastStatus != TomatoLife_Status){
        TomatoLife_LastStatus := TomatoLife_Status
    }else{
        TomatoLife_Status := ""
    }
    if(TomatoLife_Status == "工作"){
        TrayTip, , 工作时间, 1
        Send #^{F4}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}#^{Left}
        try{
            Run %USERPROFILE%/.tomato-life/on_work.bat
            Run %USERPROFILE%/.tomato-life/on_work.vbs
        }
    }
    if(TomatoLife_Status == "休息"){
        TrayTip, , 休息时间, 1
        Send #^d
        try{
            Run %USERPROFILE%/.tomato-life/on_life.bat
            Run %USERPROFILE%/.tomato-life/on_life.vbs
        }
    }
return
