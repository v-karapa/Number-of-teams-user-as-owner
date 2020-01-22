# This script will provide the teams details where user is owner for the team.
# keep the useremail id in input.csv file and run the script.

connect-microsoftteams

$input = import-csv "input.csv" -Header user | select -skip 1

    $userid = $input.user
    write-host "taking input from csv file"  
    #Section Details
    foreach($user in $userid)
    {
       $Data = get-team -User "$user"
       foreach ($teams in $Data) 
           {
                 $groupid = $teams.Groupid
                 $displayname = $teams.DisplayName
                 $owner = get-teamuser -GroupId "$groupid" -Role Owner | Where-Object {$_.User -match "$user"}
                 $owners = [string]::Join("; ",$owner.User)
                 $groupid
                 $owners

                if (!($owner -eq $null))
                    {
                    $file = New-Object psobject
                    $file | add-member -MemberType NoteProperty -Name Teams_Groupid $groupid
                    $file | add-member -MemberType NoteProperty -Name Teams_Owner $owners
                    $file | add-member -MemberType NoteProperty -Name Teams_Displayname $displayname
                    $file | export-csv output.csv -NoTypeInformation -Append
                    }
    
            }
    
    }



