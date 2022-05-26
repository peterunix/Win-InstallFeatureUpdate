$ProgressPreference="SilentlyContinue"
# https://social.technet.microsoft.com/Forums/windows/en-US/51104081-4ed7-4fdd-8b12-5d1f5be532ae/windows-10-feature-update-via-cmd-powershell-or-gpo
# Exit if not running Windows 10
$WINVER=(get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
if ( $WINVER -notlike "Windows 10*"){
  Write-Host "This script only works with Windows 10. Current OSVersion: $WINVER"
  Exit 1
}

# These folders can cause Windows Updates to fail
Remove-Item 'C:\$Windows.~WS' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'C:\$Windows.~BT' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'C:\$GetCurrent' -Recurse -Force -ErrorAction SilentlyContinue

# Downloading the file
Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?LinkID=799445' -OutFile "$env:TEMP\Win10Upgrade.exe" -UseBasicParsing

# Executing the file
Write-Host "Starting upgrade"
Start-Process -FilePath "$env:TEMP\Win10Upgrade.exe" -ArgumentList '/quietinstall /skipeula /auto upgrade /copylogs C:\Windows\Temp\FeatureUpdateLog.log' -Wait
Write-Host "The Windows update assistant is running in the background. This will take a while to complete"
