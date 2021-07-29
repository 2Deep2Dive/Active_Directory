function Sync-ADContact{
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $PathToImportFile,
        [String]
        $ADContatctsDName,
        [String]
        $ADContatctGroupsDName,
        [String]
        $SenderEmail,
        [String]
        $RecipientEmail,
        [String]
        $SMTPServer,
        [String]
        $EmailSubject
    )
    BEGIN{
        try {
            $All_OK = $false
            Write-Debug "Test if file exists"
            Write-Verbose "Test if file exists"
            if(Test-Path $PathToImportFile){
                Write-Debug "Importing contacts from file"
                $ImportedContacts = Import-CSV -Path $PathToImportFile –Delimiter ";"
                #NOTE "Use if you need to filter some contacts out"
                #$ImportedContacts = $ImportedContacts | Where-Object Mail -NotLike "*SomeThing*"
            }
            Write-Debug "Get AD conatcts"
            if(Get-ADOrganizationalUnit -Identity $ADContatctsDName){
                $ADContacts = Get-ADObject -Filter '(ObjectClass -eq "contact")' -SearchBase $ADContatctsDName -Properties *
            }
            Write-Debug "Get AD  Contacts' groups"
            if(Get-ADOrganizationalUnit -Identity $ADContatctGroupsDName){
                $ADContatcGroups = Get-adgroup -Filter * -SearchBase $ADContatctGroupsDName -Properties *
            }
        }
        catch {
            $Message = ("The Task failed!!"+"<br/>"+"Please check the file or the OUs path"+"<br/>"+$Error[0])
            $htmlbody = "<html><body><font color='#008000'>$Message</font><br /><br /><body><html>"
            Send-MailMessage -From $SenderEmail -To $RecipientEmail -Subject $EmailSubject -Body $htmlbody -BodyAsHtml -SmtpServer $SMTPServer
            Exit
        }
    }
    PROCESS{
        try {
            foreach($ImportedContact in $ImportedContacts){
                $ImportedContactCN = ((($ImportedContact.Name).Trim()) + " " + (($ImportedContact.Surname).Trim()))
                if($ADContacts.CN -contains $ImportedContactCN){
                    Write-Verbose "Contact $ImportedContactCN exists in the AD"
                    $ADContact = $ADContacts | Where-Object CN -Like $ImportedContactCN
                    if(($ImportedContact.mail) -ne ($ADContact.Mail)){
                        $ContactMail = $ImportedContact.mail
                        Write-Output "Emails do not match, email will be updated with $ContactMail"
                        Set-ADObject $ADContact -Replace @{mail="$ContactMail"}
                    }
                }
                else{
                    Write-Output "Contact $ImportedContactCN does not exist in the AD, creating new contact"
                    $Params = @{
                        Name            = $ImportedContactCN
                        path            = "OU="+($($ImportedContact.company))+","+($ADContatctsDName) #Feel free to edit this to create the proper DN path for the proper OU
                        DisplayName     = $ImportedContactCN
                        Description     = $($ImportedContact.company) # Edit for the proper description
                        Type            = "contact"
                        OtherAttributes = @{'givenName'="$(($ImportedContact.Name).Trim())";
                            'sn'        ="$(($ImportedContact.Surname).Trim())";
                            'Company'   ="$(($ImportedContact.company).Trim())";
                            'mail'      ="$(($ImportedContact.mail).Trim())";
                        }
                    }
                    New-ADObject  @Params -Verbose;
                    $ADGroup = $ADContatcGroups | Where-Object CN -like "*$($ImportedContact.Company)*"
                    Write-Output "Adding $($ImportedContact.Name) to the AD group $($ADGroup.name)"
                    Set-ADGroup -Identity $($ADGroup.CN) -Add @{'member'="$($ADContact.DistinguishedName)"} -Verbose
                }
            }
            $ADContacts = $null
            $ADContacts = Get-ADObject -Filter '(ObjectClass -eq "contact")' -SearchBase $ADContatctsDName -Properties *
            foreach($ADContact in $ADContacts){
                if(($ImportedContacts.mail -notcontains ($($ADContact.mail)))){
                    Write-Warning "$($ADContact.name) no longer exists in the import list and will be deleted!!"
                    Set-ADObject -Identity $ADContact -ProtectedFromAccidentalDeletion $false
                    Remove-ADObject -Identity $ADContact -Confirm:$false
                }
            }
            $All_OK = $true
        }
        catch {
            $Message = ("The Task failed!!"+"<br/>"+"Something went wrong when attempting to create the contact or adding it to the group"+"<br/>"+$Error[0])
            $htmlbody = "<html><body><font color='#008000'>$Message</font><br /><br /><body><html>"
            Send-MailMessage -From $SenderEmail -To $RecipientEmail -Subject $EmailSubject -Body $htmlbody -BodyAsHtml -SmtpServer $SMTPServer
        }
    }
    END{
        if($All_OK){
            $Message = ("The Task Succedded!!"+"<br/>"+"Contacts are synced"+"<br/>"+$Error[0])
            $htmlbody = "<html><body><font color='#008000'>$Message</font><br /><br /><body><html>"
            Send-MailMessage -From $SenderEmail -To $RecipientEmail -Subject $EmailSubject -Body $htmlbody -BodyAsHtml -SmtpServer $SMTPServer
        }
    }
}