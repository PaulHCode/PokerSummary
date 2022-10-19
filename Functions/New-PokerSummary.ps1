<#
.Synopsis
   Generates Tournament summary data for Poker Maves touraments
.DESCRIPTION
   Long description
.EXAMPLE
   .\New-PokerReport.ps1
.EXAMPLE
   .\New-PokerReport.ps1 -EmailFile 'C:\Users\pauharri\OneDrive - Microsoft\Documents\Poker\Reports\20221019_ReportEmails.txt' -outputDirectory 'C:\Users\pauharri\OneDrive - Microsoft\Documents\Poker\MyOutput\' -ResultsDir 'C:\Users\pauharri\OneDrive - Microsoft\Documents\Poker\TourneyResults\'

    I copied the data off the server and processed it locally on my workstation. 
.PARAMETER ResultsDir
    The path to the directory with all the results from the tournaments
.PARAMETER EmailFile
    The file exported from Poker Maves listing all emails (Accounts > Emails With Names)
.PARAMETER outputDirectory
    THe directory to put html output files for each tournament in.
.OUTPUTS
   HTML files written to the outputDirectory folder
.NOTES
   It was fun to write this in one go while on a road trip. I like it when other folks drive.
#>
[CmdletBinding()]
param ( 
    [Parameter()]
    [ValidateScript({ (test-path $_ -PathType Container) -and ((Get-ChildItem $_ -Filter *.txt).count -gt 0) })]
    [string]
    $ResultsDir = 'C:\Users\GOPAdmin\AppData\Roaming\Poker Mavens 6\TourneyResults', #'C:\Users\pauharri\OneDrive - Microsoft\Documents\Poker\TourneyResults',
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]
    $EmailFile, #= 'C:\Users\pauharri\OneDrive - Microsoft\Documents\Poker\Reports\20221019_ReportEmails.txt',
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]
    $outputDirectory #= 'C:\Users\pauharri\OneDrive - Microsoft\Documents\Poker\MyOutput\'
)

$EmailHash = Get-Content $EmailFile | ForEach-Object {

    $email = $_.split(' ')[1]
    $email = ([string]$email[1..($email.length - 2)]).Replace(' ', '')
    @{
        $_.split(' ')[0] = $email
    }
}

Write-Host 'Your computer is dumb and puts the popup behind this window. Go use the pop-under window.' -ForegroundColor Black -BackgroundColor White
$TournamentsToProcess = Get-ChildItem $ResultsDir -Filter *.txt | Out-GridView -PassThru -Title 'Select one or more tournaments to process'
If ($Null -eq $TournamentsToProcess) {
    throw 'you must select a tournament to process'
}

$allPlaces = ForEach ($tournament in $TournamentsToProcess) {
    $fileContents = Get-Content $tournament.FullName    
    $AbortionTotal = ($fileContents | Where-Object { $_ -eq $fileContents[0] }).Count
    #check for abortions - If they start a tournament, then abort it, then start it again, it all goes to the same log file
    If ($AbortionTotal -gt 1) {
        $AbortionCounter = 0
        $line = 0
        #For($line=0;$AbortionCounter -eq $AbortionTotal;$line++){
        While ($AbortionTotal -ne $AbortionCounter) {
            If ($fileContents[$line] -eq $fileContents[0]) {
                $AbortionCounter++
            }
            $line++
        }
        $fileContents = $fileContents[($line - 1)..($fileContents.Count)]
    }
    #    "Line: $line"
    #    "Abortion Counter: $abortioncounter"


    $fileContents = ($fileContents | Where-Object { $_ -Match '^Place.*=.*' }) #get rid of lines in the log file that are not place information lines since that is all we care about
    
    $fileContents | ForEach-Object {
        $UserName = $_.split('=')[1].split(' ')[0]  #$_.split(' ')[0].split('=')[1]
        #Write-Host "$tournament - $UserName"
        [pscustomobject]@{
            Tournament   = ([string]$tournament.Name[($tournament.Name.IndexOf(' ') + 1)..($tournament.Name.Length - 5)]).Replace(' ', '')
            Place        = [int]$_.Split('=')[0].split('e')[1] #[int]($_.Split('Place')[0].split('=')[0]) #$_.Split('Place')[1].split('=')[0] #[int]($_.Split('=')[0].split('e')[1])
            UserName     = $UserName
            Rebuys       = If ($_.contains('Rebuys:')) { $_.Split('Rebuys:')[1].Split(' ')[0] }Else { 0 }  #$_.Split(' ')[2].Split(':')[1]
            Addon        = If ($_.contains('AddOn:')) { $_.Split('AddOn:')[1].Split(' ')[0] }Else { 'No' } #$_.Split(' ')[3].Split(':')[1]
            KnockedOutBy = If ($_.contains('KO:')) { $_.Split('KO:')[1].Split(' ')[0] }Else { 'unknown' } #$_.Split(' ')[4].Split(':')[1]
            Email        = $($EmailHash.$UserName)
        }
    }
}

If (($allPlaces | Where-Object { $Null -eq $_.email }).count -gt 0) {
    Write-Warning @'
        The data is complete due to an out of date Email file.
        To get a new email file: 
            1. Open the Poker Maves GUI, 
            2. Select the 'Accounts' tab
            3. Select all entries
            4. Select the 'Export' menu then the 'Emails with Names' option
            5. Rerun this code with the proper email file specified
'@
}


############Export to pretty format

ForEach ($tournament in ($allPlaces.Tournament | Select-Object -Unique)) {
    $outputFile = Join-Path $outputDirectory "$tournament.html"
    $thisTournament = $allPlaces | Where-Object { $_.Tournament -eq $tournament }
    [string]$HTMLReport = ''
    $HTMLReport = New-HTMLReport -Title 'Poker Tournament Results'
    <#
    $Header = @{
        TournamentName = $tournament
        TournamentDirector = 'unknown'
        NumberOfParticipants = ($thisTournament.count)
        NumberOfRebuys = ($thisTournament.Rebuys | Measure-Object -Sum).Sum
        NumberOfAddons = ($thisTournament.Addon  -eq 'Yes').Count 
        Winner = ($thisTournament | Where-Object { $_.Place -eq 1 }).Email
    }

    $HTMLReport += New-HTMLReportSection -SectionTitle 'Summary' -SectionContents $Header
 
#>

    $HTMLReport += New-HTMLReportHeader -TournamentName $tournament `
        -TournamentDirector 'unknown' `
        -NumberOfParticipants ($thisTournament.count) `
        -NumberOfRebuys ($thisTournament.Rebuys | Measure-Object -Sum).Sum `
        -NumberOfAddons ($thisTournament.Addon -eq 'Yes').Count `
        -Winner ($thisTournament | Where-Object { $_.Place -eq 1 }).Email
    
    $HTMLReport += New-HTMLReportSection -SectionTitle 'Players' -SectionContents ($thisTournament | Sort-Object Place -Descending)

    $HTMLReport | Out-File (Join-Path $outputDirectory "$tournament.html")

}
