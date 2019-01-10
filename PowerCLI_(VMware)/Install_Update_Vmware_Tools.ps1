$Server = "example"
$VM = "example"

Connect-Viserver -server $Server
Mount-Tools -VM $VM
Invoke-VMScript -VM $VM -ScriptText {'<DRIVE>:\setup64.exe /s /v "/qn reboot=r"'} -ScriptType Powershell -GuestUser GUser -GuestPassword GPassword
Dismount-Tools -VM $VM
Update-Tools -VM $VM -NoReboot -Server $_.vCenterConnectionPoint | Wait-Tools
