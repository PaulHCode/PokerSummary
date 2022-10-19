Function New-HTMLReport {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Title
    )
    "<H1 id=$('"'+$($Title.Replace(' ',''))+'"')>$($title)</H1><br>`n"
}