@{
    # If authoring a script module, the RootModule is the name of your .psm1 file
    RootModule = 'Sync-ADContacts.psm1'

    Author = 'Mohamed Eliwa <mohamed.eliwa@outlook.com>'

    CompanyName = ''

    ModuleVersion = '0.1'

    # Use the New-Guid command to generate a GUID, and copy/paste into the next line
    GUID = '1056419a-4f94-4f86-9f46-5ce1e142c874'

    Copyright = '2021 Copyright Holder'

    Description = 'Sync contacts information between a CSV file and Active Directory, and remove older contacts '

    # Minimum PowerShell version supported by this module (optional, recommended)
    # PowerShellVersion = ''

    # Which PowerShell Editions does this module work with? (Core, Desktop)
    CompatiblePSEditions = @('Desktop', 'Core')

    # Which PowerShell functions are exported from your module? (eg. Get-CoolObject)
    FunctionsToExport = @('Sync-ADContacts')

    # Which PowerShell aliases are exported from your module? (eg. gco)
    AliasesToExport = @('')

    # Which PowerShell variables are exported from your module? (eg. Fruits, Vegetables)
    VariablesToExport = @('PathToImportFile,ADContatctsDName,ADContatctGroupsDName,SenderEmail,RecipientEmail,SMTPServer,EmailSubject')

    # PowerShell Gallery: Define your module's metadata
    PrivateData = @{
        PSData = @{
            # What keywords represent your PowerShell module? (eg. cloud, tools, framework, vendor)
            Tags = @('Active Directory', 'Microsft', 'Contacts', 'tools', 'sync')

            # What software license is your code being released under? (see https://opensource.org/licenses)
            LicenseUri = 'https://opensource.org/licenses'

            # What is the URL to your project's website?
            ProjectUri = 'https://github.com/2Deep2Dive/Active_Directory'

            # What is the URI to a custom icon file for your project? (optional)
            IconUri = ''

            # What new features, bug fixes, or deprecated features, are part of this release?
            ReleaseNotes = @'
'@
        }
    }

    # If your module supports updateable help, what is the URI to the help archive? (optional)
    # HelpInfoURI = ''
}