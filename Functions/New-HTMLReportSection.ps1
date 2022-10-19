Function New-HTMLReportSection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SectionTitle,
        [Parameter()]
        [array]
        $SectionContents = $Null
    )
    $emptyNote = [PSCustomObject]@{message = '[empty]' }
    $MyOut = @()
    $MyOut += "<br><H2 id=$('"'+$($SectionTitle.Replace(' ',''))+'"')>$SectionTitle</H2>`n"
    If ($SectionContents -eq '' -or $SectionContents -eq $Null) {
        $MyOut += "<br>$($emptyNote | Select-Object message | ConvertTo-HTML -Fragment)`n"
    }
    Else {
        $MyOut += "<br>$($SectionContents | ConvertTo-Html -Fragment)`n"
    }
    $MyOut
}