#(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices  -Filter "TerminalName='RDP-tcp'").UserAuthenticationRequired
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices  -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices  -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(1)
