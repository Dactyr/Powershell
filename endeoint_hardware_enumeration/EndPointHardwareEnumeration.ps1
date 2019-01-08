<#
INSTRUCTIONS:

To use this script it requires a proper file path in place of the "<Your desired Path>".

A quick way to do this is to press ctrl-H hotkey and choose to replace all "<Your desired Path>"
with the desired path.

Once this is completed you should be able to run the script and it create the folder paths required to run properly.

The names are in the file path "<Your desired Path>\EPHE\EPHE Output\names"

The full hardware list is located in "<Your desired Path>EPHE\EPHE Output"

DESCRIPTION:

EPHE stands for End Point Hardware Enumeration

This Scripts current Version is Version 2.4

This version uses WMI queries to gather this information because in the environment it was developed in WinRM was not
uniformly configured across all devices severely limiting commands such as invoke-command or get-ciminstance.

In future versions the script will be modified to use workflows and
CIM instance queries to provide better parallel performance and reduced script run time.

Current average Script run time is approximately 20-30 mins per 1000 end point devices, this time is greatly influenced
by CPU RAM IOPS and Network speed available not in that particular order.

This Script is designed to gather all devices attached to Active Directory and then gather all relevant hardware data
and export the data to a CSV file.

This Script also gathers all failed connection and positive connection devices on the network and separates the names based
on a connection test.

This version uses WMI queries to gather this information, in future versions the script will be modified to use workflows and
CIM instance queries to provide better parallel performance and reduced script run time.

This script is modular and is separated via the titles the resemble the example below:

#########################
## Example Description ##
#########################

This means that each section of the script separated with this type of Section title can be run separately in sequence and
still provide the same output in the end.

Every time this Script is ran it will archive and place a timestamp on the

UPDATES:

This script will be periodically updated as new features or more efficient data handling is introduced.

All current and previous versions will be available on my Git-Hub Repository "Git-Hub Repo URL Here"
#>

#########################################################################################
## This Section Prepares File Space For The Processes Below to ensure Accuracy Of Data ##
#########################################################################################

mkdir "<Your desired Path>\EPHE\EPHE Output\names" -ErrorAction SilentlyContinue
mkdir "<Your desired Path>\EPHE\EPHE Output" -ErrorAction SilentlyContinue
mkdir "<Your desired Path>\EPHE\EPHE Archive" -ErrorAction SilentlyContinue
mkdir "<Your desired Path>\EPHE\EPHE rawdata" -ErrorAction SilentlyContinue
mkdir "<Your desired Path>\EPHE\EPHE Errors" -ErrorAction SilentlyContinue

$namepath = "<Your desired Path>EPHE\EPHE Output\names"
$outpath = "<Your desired Path>EPHE\EPHE Output"
$archivepath = "<Your desired Path>EPHE\EPHE Archive"
$rawpath = "<Your desired Path>EPHE\EPHE rawdata"
$errorpath = "<Your desired Path>EPHE\EPHE Errors"
$time = Get-Date -Format yyyyMMddHHmmss

If(get-item -Path "$outpath\Compinfo.csv" -ErrorAction SilentlyContinue)
    {
    Get-item -Path "$outpath\Compinfo.csv" | Move-Item -Destination "$archivepath\Compinfo$time.csv"
    }


Remove-item -Path "$rawpath\*" -Force -ErrorAction SilentlyContinue

#####################################################################################
## This Section Gathers All Computer Names in Active Directory Into reference File ##
#####################################################################################

Workflow Get-CompNames
{
    $comps = Get-ADComputer -Filter {Name -notlike "*Local*"} -Property "name"
    $comps = $comps.name
    $namepath = "<Your desired Path>EPHE\EPHE Output\names"
    $compcp = @()
    $fcompcp = @()

    foreach -parallel ($comp in $comps)
    {
        If(test-connection -computername $comp -Count 2 -ErrorAction SilentlyContinue)
        {
            $WORKFLOW:compcp +=($comp)
        }

        Else
        {
            $fhst = $comp
            $WORKFLOW:fcompcp +=($fhst)
        }
    }
    out-file -InputObject $fcompcp -filepath "$namepath\FWKSname.csv" -Force -NoClobber
    out-file -InputObject $compcp -filePath "$namepath\WKSname.csv" -Force -NoClobber
}
Get-CompNames

########################################################################################
## Using Computername Reference File, This Section Gathers All Required Hardware Data ##
########################################################################################

$comps = Get-content -Path "$namepath\WKSname.csv"
$compsperbatch = 41
$i= 1
$j = $compsperbatch
$batch = 1
while ($i -lt $comps.count)
{
    $compbatch = $comps[$i..$j]
    $jobname = "Batch$batch"
    Start-job -Name $jobname -ScriptBlock{
        param ([string[]]$comps)
        foreach ($comp in $comps)
        {
            try
            {
            $rawpath = "<Your desired Path>EPHE\EPHE rawdata"
            $errorpath = "<Your desired Path>EPHE\EPHE Errors"
            $time = get-date -format yyyyMMddHHmmss
            $os = Get-Wmiobject -ComputerName $comp -Class Win32_OperatingSystem -ErrorAction SilentlyContinue
            $model = Get-WmiObject -ComputerName $comp -Class Win32_Computersystem -ErrorAction SilentlyContinue
            $proc = Get-WmiObject -ComputerName $comp -Class win32_processor -ErrorAction SilentlyContinue
            $proc = $proc.name
            $mem = Get-WmiObject -ComputerName $comp -Class Win32_Physicalmemory -ErrorAction SilentlyContinue | Select-Object Capacity
            $memp = $mem.partnumber
            $memc = $mem.Capacity
            $memc1 = $memc[0]
            $memc2 = $memc[1]
            $memc3 = $memc[2]
            $memc4 = $memc[3]
            $memc5 = $memc[4]
            $memc6 = $memc[5]
            $memc7 = $memc[6]
            $memc8 = $memc[7]
            $memc9 = $memc[8]
            $memc10 = $memc[9]
            $memc11 = $memc[10]
            $memc12 = $memc[11]
            $memc13 = $memc[12]
            $memc14 = $memc[13]
            $memc15 = $memc[14]
            $memc16 = $memc[15]
            $memc17 = $memc[16]
            $memc18 = $memc[17]
            $memc19 = $memc[18]
            $memc20 = $memc[19]
            $memc21 = $memc[20]
            $memc22 = $memc[21]
            $memc23 = $memc[22]
            $memc24 = $memc[23]
            $memp1 = $memp[0]
            $memp2 = $memp[1]
            $memp3 = $memp[2]
            $memp4 = $memp[3]
            $Totmem = $memc1 + $memc2 + $memc3 + $memc4 + $memc5 + $memc6 + $memc7 + $memc8 + $memc9 + $memc10 + $memc11  + $memc12 + $memc13 + $memc14 + $memc15 + $memc16 + $memc17 + $memc18 + $memc19 + $memc20 + $memc21 + $memc22 + $memc23 + $memc24
            $Disk = Get-WmiObject -ComputerName $comp -class Win32_LogicalDisk -filter "DeviceID='c:'" -ErrorAction SilentlyContinue
            $Prop = [ordered]@{
                'ComputerName' = $comp;
                'Operating System' = $os.caption;
                'OS Build' = $os.buildnumber;
                'Manufacturer' = $model.manufacturer;
                'Computer Model' = $model.model;
                'Processor' = $proc;
                'Memory 1 Partnumber' = $memp1;
                'Memory 2 Partnumber' = $memp2;
                'Memory 3 Partnumber' = $memp3;
                'Memory 4 Partnumber' = $memp4;
                'Memory Capacity (GB)'=$totmem / 1gb -as [int];
                'FreeSpace (GB)'=$Disk.freespace / 1gb -as [int]
                'HDD Size (GB)' =$Disk.size / 1gb -as [int];
                }
            $batch += 1
            $obj = New-Object -TypeName PSObject -Property $prop
            Export-csv -InputObject $obj -Path "$rawpath\Compinfo$batch.csv" -Append -Force
            }
            catch
            {
            $($_.Exception.Message) | Out-File -filepath "$errorpath\errors$time.txt" -Append
            }
        }
    } -ArgumentList (,$compbatch)
    $Batch +=1
    $i = $j + 1
    $j += $compsperbatch
    if ($i -gt $comps.count) {$i = $comps.count}
    if ($j -gt $comps.count) {$j = $comps.count}
}


################################################################################
## This Section Removes Completed Jobs As They Complete From Previous Section ##
################################################################################

Try
{
    do
    {
    $jobs = Get-Job
    $jobs = $jobs.Name
    foreach($job in $jobs)
    {
        If ((get-job -name "$job" -ErrorAction Continue).state -ne "running")
            {
            Get-Job -Name "$job" -ErrorAction Continue|
            Receive-Job -Keep -ErrorAction Continue
            Remove-Job -Name "$job" -Force
            }
        }
    }
    Until(($jobs) -eq $null)
}
catch
{
    $($_.Exception.Message) | Out-File -filepath "$errorpath\Joberrors.txt" -Append
}

########################################################
## This Section Combines Job output into a Single CSV ##
########################################################

$acsv = Get-ChildItem $rawpath -filter *.csv | Where-Object {$_.basename -like "Compinfo*"}
import-csv -LiteralPath $acsv.fullname | Sort-Object ComputerName | export-csv -Path "$outpath\Compinfo.csv"

########################################
## This Completes Excess File Cleanup ##
########################################

Remove-item -Path "$rawpath\*"
