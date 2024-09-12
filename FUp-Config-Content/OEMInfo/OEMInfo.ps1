<# 
Name: 		OEMInfo.ps1
Date: 		2019.07.26
Version:	1.0 
Author:		Firdous Anjillan
#>

$cs = Get-WmiObject -Class Win32_ComputerSystem
$csVer = Get-WmiObject -Class Win32_ComputerSystemProduct

Copy-Item -Path "$PSScriptRoot\OEMLogo.bmp" -Destination "$Env:systemroot\system32\" -Force

$manufacturer = $cs.Manufacturer
$model = $cs.Model
$sysSKU = $cs.SystemSKUNumber
$devVersion = $csVer.version


if(-not (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation"))
{
    New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion" -Name "OEMInformation"
}
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name Logo -PropertyType String -Value "%systemroot%\system32\OEMLogo.bmp" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name Manufacturer -PropertyType String -Value "$manufacturer - [ISC/CIRNAC]" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name Model -PropertyType String -Value "$model" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name SystemSKU -PropertyType String -Value "$sysSKU" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name Version -PropertyType String -Value "$devVersion" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name SupportHours -PropertyType String -Value "Monday through Friday, 7 AM to 8 PM EST" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name SupportPhone -PropertyType String -Value "1-866-795-6465" -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation" -Name SupportUrl -PropertyType String -Value "http://intranet-rcaanc-cirnac/eng/1399649218972/1403288097450" -Force