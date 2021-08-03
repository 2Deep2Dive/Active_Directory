# Active_Directory
PowerShell scripts for administrating Active Directory

Functions
---------
<h2>SyncADContacts</h2>
The function sync imported user's data from a CSV file and it either creates new AD contacts or update the email is already existed, it added the new contacts to a specific group
It also removes any contacts in the AD that no longer exists in the import file

Expects a CSV file with the following data and format
name;surname;company;mail


Note
----
This repository is mirrored to a project hosted at GitLab.com
