<#
    Filename:   RemoveApps_Cloud.ps1
    Version:    1.1
    Author:     Firdous Anjillan and Gabriel Brunet
    Date:       2024-08-29  
    .Description
    PowerShell script to remove pre-installed apps (bloatware) from Windows 11.
#>

<#
.SYNOPSIS
  Remove bloatware apps from Windows 10 or Windows 11
.DESCRIPTION
  PowerShell script to remove pre-installed apps (bloatware) from Windows 11.
.INPUTS
  None
.OUTPUTS
  Log file stored at C:\Windows\Temp\Remove-UnwantedAppsCloud.log
.NOTES
  Version:        1.1
  Author:         Firdous Anjillan and Gabriel Brunet
  Creation Date:  2024-08-29
  
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
#region Initialisations

# Check for administrative privileges
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You do not have Administrator rights to run this script. Please run this script as an Administrator."
    exit 1
}

#endregion Initialisations


#-----------------------------------------------------------[Functions]------------------------------------------------------------
#region Functions

# Logging function
function Write-LogEntry {
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Value,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$FileName = "Remove-UnwantedAppsCloud.log",
        [switch]$Stamp
    )
    
    # Build Log File appending System Date/Time to output
    $LogFile = Join-Path -Path $env:SystemRoot -ChildPath "Temp\$FileName"
    $Time = -join @((Get-Date -Format "HH:mm:ss.fff"), " ", (Get-WmiObject -Class Win32_TimeZone | Select-Object -ExpandProperty Bias))
    $Date = (Get-Date -Format "MM-dd-yyyy")
    
    If ($Stamp) {
        $LogText = "<$($Value)> <time=""$($Time)"" date=""$($Date)"">"
    }
    else {
        $LogText = "$($Value)"   
    }
    
    Try {
        Out-File -InputObject $LogText -Append -NoClobber -Encoding Default -FilePath $LogFile -ErrorAction Stop
    }
    Catch [System.Exception] {
        Write-Warning -Message "Unable to add log entry to $LogFile.log file. Error message at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
    }
}

#endregion Functions


#----------------------------------------------------------[Declarations]----------------------------------------------------------
#region Declarations

$OSVersion = [System.Environment]::OSVersion

# Variables
if ($OSVersion -match [Version]"10.0.1") {
    # $CapabilitiesUrl = "https://raw.githubusercontent.com/anjillan/public/main/Capabilities22631.txt"
    # $CapabilitiesFile = "$env:SystemRoot\Temp\Capabilities22631.txt"

    $AppListUrl = "https://raw.githubusercontent.com/JeeBee14/FileRepo/main/Win10Apps.txt"
    $AppListFile = Join-Path -Path $env:SystemRoot -ChildPath "Temp\Win10Apps.txt"
}
elseif ($OSVersion -match [Version]"10.0.2") {
    # $CapabilitiesUrl = "https://raw.githubusercontent.com/anjillan/public/main/Capabilities22631.txt"
    # $CapabilitiesFile = "$env:SystemRoot\Temp\Capabilities22631.txt"

    $AppListUrl = "https://raw.githubusercontent.com/JeeBee14/FileRepo/main/Win11Apps.txt"
    $AppListFile = Join-Path -Path $env:SystemRoot -ChildPath "Temp\Win11Apps.txt"
}

#endregion Declarations


#-----------------------------------------------------------[Execution]------------------------------------------------------------
#region Execution

Write-LogEntry -Value "##################################"
Write-LogEntry -Stamp -Value "Remove-Appx Started"
Write-LogEntry -Value "##################################"

# Download the capabilities and app list files
# try {
#     Invoke-WebRequest -Uri $CapabilitiesUrl -OutFile $CapabilitiesFile -UseBasicParsing -ErrorAction Stop
#     Write-LogEntry -Value "Downloaded capabilities file from $CapabilitiesUrl"
# }
# catch {
#     Write-LogEntry -Value "ERROR: Failed to download capabilities file from $CapabilitiesUrl"
# }

try {
    Invoke-WebRequest -Uri $AppListUrl -OutFile $AppListFile -UseBasicParsing -ErrorAction Stop
    Write-LogEntry -Value "Downloaded app list file from $AppListUrl"
}
catch {
    Write-LogEntry -Value "ERROR: Failed to download app list file from $AppListUrl"
}

# Check for capabilities file and remove capabilities
# if (Test-Path $CapabilitiesFile) {
#     $Capabilities = Get-Content $CapabilitiesFile
#     Write-LogEntry -Value "Removing Windows capabilities from file $CapabilitiesFile"

#     ForEach ($Capability in $Capabilities) {
#         try {
#             Write-LogEntry -Value "Removing capability: $Capability"
#             Remove-WindowsCapability -Online -Name $Capability -ErrorAction Stop | Out-Null
#         }
#         catch {
#             Write-LogEntry -Value "ERROR: Failed to remove capability: $Capability"
#         }
#     }
# }
# else {
#     Write-LogEntry -Value "No capabilities file found"
# }

# Uninstall apps from the text file
if (Test-Path $AppListFile) {

    # Get Apps from file
    Write-LogEntry -Value "Removing built-in apps from file $AppListFile"
    $Applist = Get-Content $AppListFile    

    # Get All Packages once to reduce delay
    $AllAppxPackages = Get-AppxPackage -AllUsers
    $AllAppxProvisionedPackages = Get-AppxProvisionedPackage -Online

    ForEach ($App in $Applist) {

        $App = $App.TrimEnd()
        
        # Find packages
        $PackageFullName = ($AllAppxPackages | Where-Object { $_.Name -eq $App }).PackageFullName
        $ProPackageFullName = ($AllAppxProvisionedPackages | Where-Object { $_.DisplayName -eq $App }).PackageName

        # Remove Appx Package
        try {
            if (-not [String]::IsNullOrWhiteSpace($PackageFullName)) {
                Write-LogEntry -Value "Removing installed app package: $PackageFullName"
                $null = Remove-AppxPackage -Package $PackageFullName -AllUsers -ErrorAction Stop
            }
            else {
                Write-LogEntry -Value "WARNING: $App App package not found"
            }
        }
        catch {
            Write-LogEntry -Value "ERROR: Failed to remove $App with the following error: $($_.Exception)"
        }        

        # Remove Appx Provisioned Package
        try {
            if (-not [String]::IsNullOrWhiteSpace($ProPackageFullName)) {
                Write-LogEntry -Value "Removing provisioned package: $ProPackageFullName"
                $null = Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName -AllUsers -ErrorAction Stop
            }
            else {
                Write-LogEntry -Value "WARNING: Provisioned package not found: $App"
            }
        }
        catch {
            Write-LogEntry -Value "ERROR: Failed to remove $App with the following error: $($_.Exception)"
        } 
    }
}
else {
    Write-LogEntry -Value "No app list file found"
}

Write-LogEntry -Value "Script completed." -Stamp

#endregion Execution