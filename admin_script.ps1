
#Set variables
$path = Read-Host "Enter the file path you wish to check"
$emailFrom = Read-Host "Enter the Email From"
$emailTo = Read-Host "Enter the Email To"
$emailSubject = Read-Host "Enter the Subject Email"
$emailBody = Read-Host "Enter the Body Email"
$smtpServer = Read-Host "Enter the Smtp Server"

$date = Get-Date
New-Item C:\Scripts\Result.txt -type file -Force
$file = "C:\Scripts\Result.txt"
$strcomputer = gc $path

#Place Headers on out-put file
$list = "Administrators in: $Path"
$list | Format-Table | Out-File "$file"
$datelist = "Report Run Time: $date"
$datelist | Format-Table | Out-File -Append "$file"
$spacelist =  " "
$spacelist | Format-Table | Out-File -Append "$file"
  
 
$admins = Gwmi win32_groupuser –computer $strcomputer   
$admins = $admins |? {$_.groupcomponent –like '*"Administrators"'}  
  
$admins |% {  
$_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul  
$matches[1].trim('"') + “\” + $matches[2].trim('"')  
} |Out-File -Append "$file"


Send-MailMessage -From $emailFrom -To $emailTo -Subject $emailSubject -Body  $emailBody -Attachments $file -Priority High -DeliveryNotificationOption OnSuccess, onFailure -SmtpServer $smtpServer


