$Users = Import-Csv -Path C:\Users\Administrator\Desktop\email.csv -Delimiter ';' | Where-Object{$_.company -notlike "Profidata*"}
foreach ($User in $Users){
    if(($User.Company -notlike "AI") -and ($User.Company -notlike "SKAG")){
    $mail = $User.mail
    $GivenName = $User.name
    $SurName = $User.surname
     New-ADObject -Name (($User.name)+(" ")+($User.surname))  -Type "contact" -ProtectedFromAccidentalDeletion $True -DisplayName (($User.name)+(" ")+($User.surname)) -Path (("OU=")+($User.company)+(",OU=PD XCloud,OU=Profidata_Users,OU=Profidata,DC=profidata,DC=com")) -OtherAttributes @{'mail'="$mail";'givenname'="$GivenName";'sn'="$SurName"} -Verbose
    }
}