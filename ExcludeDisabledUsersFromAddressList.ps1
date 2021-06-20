Import-Module ActiveDirectory

# Формируем список пользователей, которые находятся в OU
$Disabled_users_ou = @('OU=DisabledAccounts,OU=Users,OU=BRANCHOFFICE,OU=ACCOUNT,DC=ACCOUNT,DC=com', 'OU=DisabledAccounts,OU=Users,OU=HeadOffice,OU=ACCOUNT,DC=ACCOUNT,DC=com')

foreach ($i in 1..[int]$Disabled_users_ou.Count) { 
    # Write-Host $Disabled_users_ou[$i-1]
    $User_List = Get-ADUser -Filter {(mail -ne "null") -and (Enabled -eq "false")} -SearchBase $Disabled_users_ou[$i-1] | Select-object `
        DistinguishedName,Name,UserPrincipalName,samaccountname

    foreach ($user in $User_List) {
        Write-Host $User.samaccountname
        Set-ADObject -Identity $User.DistinguishedName -replace @{msExchHideFromAddressLists=$true}
        Set-ADObject -Identity $User.DistinguishedName –clear ShowinAddressBook
    }   
}