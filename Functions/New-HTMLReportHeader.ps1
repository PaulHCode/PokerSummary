Function New-HTMLReportHeader {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TournamentName,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TournamentDirector,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NumberOfParticipants,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NumberOfRebuys,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NumberOfAddons,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Winner
    )

    $TournamentName = "Tournament Name: $TournamentName"
    $TournamentDirector = "Tournament Director: $TournamentDirector"
    $NumberOfParticipants = "Number of Participants: $NumberOfParticipants"
    $NumberOfRebuys = "Number of Rebuys: $NumberOfRebuys"
    $NumberOfAddons = "Number of Addons: $NumberOfAddons"
    $Winner = "Winner: $Winner"

    "<H2 id=$('"'+$($TournamentName)+'"')>$($TournamentName)</H2>"
    "<H2 id=$('"'+$($TournamentDirector)+'"')>$($TournamentDirector)</H2>"
    "<H2 id=$('"'+$($NumberOfParticipants.Replace(' ',''))+'"')>$($NumberOfParticipants)</H2>"
    "<H2 id=$('"'+$($NumberOfRebuys.Replace(' ',''))+'"')>$($NumberOfRebuys)</H2>"
    "<H2 id=$('"'+$($NumberOfAddons.Replace(' ',''))+'"')>$($NumberOfAddons)</H2>"
    "<H2 id=$('"'+$($Winner.Replace(' ',''))+'"')>$($Winner)</H2>"
}
