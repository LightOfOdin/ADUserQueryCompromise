#Author: David Oraha
#Helpfuls: - https://docs.microsoft.com/en-us/powershell/scripting/samples/viewing-object-structure--get-member-?view=powershell-7.1
#          - https://docs.microsoft.com/en-us/powershell/module/addsadministration/get-aduser?view=win10-ps
#          - Stack Overflow ;)

$DNSServer1 = #Enter a global catalog domain.Format: <dnsname>:3268
$DNSServer2 = #Enter a global catalog domain.Format: <dnsname>:3268

#Domain1 Retrival Function
function Domain1 {
    param (
        $UsersDomain1
    )
    $UsersDomain1 = Get-Content '.\LeakedUsers.txt' # Defines document location and retrieves the content.
Get-ADUser -Server $DNSServer1 -Filter '*' -Properties mail | # Selects every user in AD. Matches UserPrinciple Property
    Where-Object { $UsersDomain1 -contains $_.SamAccountName } | #Every user in the text document that matches the email, will get piped.
    Select-Object mail, GivenName, Surname, Enabled | # Pull releveant fields from piped users
    Export-Csv '.\ADResultDomain1.csv' -NoType #Outputs as a CSV file to work through.
}

#Domain2 Retrival Function
function Domain2 {
    param (
        $UsersDomain2
    )
    $UsersDomain2 = Get-Content '.\LeakedUsers.txt' # Defines document location and retrieves the content.
    Get-ADUser -Server $DNSServer2 -Filter '*' -Properties mail | # Selects every user in AD. Matches SamAccountName Property
        Where-Object { $UsersDomain2 -contains $_.SamAccountName } | #Every user in the text document that matches the email, will get piped.
        Select-Object mail, GivenName, Surname, Enabled | # Pull releveant fields from piped users
    Export-Csv '.\ADResultDomain2.csv' -NoType #Outputs as a CSV file to work through.
}


#Call the above functions.
Domain1
Domain2

