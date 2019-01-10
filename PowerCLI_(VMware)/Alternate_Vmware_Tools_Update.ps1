$servernameorip = "example"
$datacenter = "example"
$cluster = "example"
$folder = "example"

Connect-VIServer $servernameorip
# update all vms in datacenter
Get-VM -Location (Get-Datacenter $datacenter) | Update-Tools -NoReboot –RunAsync
#update all vms in cluster
Get-VM -Location (Get-Cluster $cluster) | Update-Tools -NoReboot –RunAsync
#update all vms in orgnaization folder
Get-VM -Location (Get-Folder $folder) | Update-Tools -NoReboot –RunAsync
