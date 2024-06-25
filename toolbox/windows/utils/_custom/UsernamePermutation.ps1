 #!/usr/bin/env pwsh

<#
.SYNOPSIS
    Generates permutations of usernames from a file containing names.

.DESCRIPTION
    This function reads a file containing names, processes each name to generate various username permutations,
    and outputs the permutations to the console. Optionally, the output can also be saved to a specified file.

.PARAMETER NamesFile
    The path to the file containing names.

.PARAMETER Output
    An optional path to a file where the username permutations will be saved.

.EXAMPLE
    Invoke-UsernamePermutation -NamesFile "names.txt"

    Generates and displays username permutations for the names in "names.txt".

.EXAMPLE
    Invoke-UsernamePermutation -NamesFile "names.txt" -Output "output.txt"

    Generates username permutations for the names in "names.txt" and saves them to "output.txt".

.NOTES
    Author: Kike Fontán (@cosasdepuma)
#>
function Invoke-UsernamePermutation {
    param (
        [Parameter(Mandatory=$true)]
        [string]$NamesFile,

        [Parameter(Mandatory=$false)]
        [string]$Output
    )

    if (-not (Test-Path $NamesFile)) {
        Write-Output "$NamesFile not found"
        return
    }

    $results = @()

    Get-Content $NamesFile | ForEach-Object {
        $name = -join ($_ -replace '[^a-zA-Z ]', '').Trim()

        if (-not $name) {
            return
        }

        $tokens = $name.ToLower().Split()

        if ($tokens.Count -lt 1) {
            return
        }

        $fname = $tokens[0]
        $lname = $tokens[-1]

        $permutations = @(
            "$fname$lname"          # johndoe
            "$lname$fname"          # doejohn
            "$fname.$lname"         # john.doe
            "$lname.$fname"         # doe.john
            "$lname$($fname[0])"    # doej
            "$($fname[0])$lname"    # jdoe
            "$($lname[0])$fname"    # djoe
            "$($fname[0]).$lname"   # j.doe
            "$($lname[0]).$fname"   # d.john
            "$fname"                # john
            "$lname"                # doe
        )

        $results += $permutations
        $permutations | ForEach-Object { Write-Output $_ }
    }

    if ($Output) {
        $results | Out-File -FilePath $Output
    }
}

# Example usage:
# Invoke-UsernamePermutation -NamesFile "names.txt"
# Invoke-UsernamePermutation -NamesFile "names.txt" -Output "output.txt" 