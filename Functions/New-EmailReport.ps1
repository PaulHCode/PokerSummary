
Function New-EmailReport{
<#
.SYNOPSIS
    Generates a report of player emails from a Poker Mavens server.

.DESCRIPTION
    The New-EmailReport function generates a report of player emails from a Poker Mavens server. It uses the Send-PokerMavensRestCommand function to retrieve the player and email information from the server and outputs the results in a format that can be used for email communication.

.PARAMETER Protocol
    Specifies the protocol to use for the connection to the Poker Mavens server. Valid values are 'http' and 'https'. The default value is 'https'.

.PARAMETER ServerName
    Specifies the name or IP address of the Poker Mavens server to connect to.

.PARAMETER Port
    Specifies the port number to use for the connection to the Poker Mavens server. The default value is 443.

.PARAMETER Password
    Specifies the password to use for the connection to the Poker Mavens server.

.PARAMETER ApiPath
    Specifies the API path to use for the connection to the Poker Mavens server.

.EXAMPLE
    PS C:\> New-EmailReport -Protocol https -ServerName mypokerserver.com -Port 443 -Password mypassword -ApiPath /api/ -Verbose

    John Smith <john.smith@email.com>
    Jane Doe <jane.doe@email.com>

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('http', 'https')]
        [string]
        $Protocol = 'https',
        [Parameter(Mandatory = $true)]
        [string]
        $ServerName,
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 65535)]
        [int]
        $Port = 443,
        [Parameter(Mandatory = $true)]
        [string]
        $Password,
        [Parameter(Mandatory = $true)]
        [string]
        $ApiPath
    )
    $CommandSet = 'AccountsList&Fields=Player,Email'
    $Method = 'Get'

    $result = Send-PokerMavensRestCommand -Protocol $Protocol -ServerName $ServerName -Port $Port -Password $Password -ApiPath $ApiPath -CommandSet $CommandSet -Method $Method

    For($i = 0;$i -lt $result.Player.count;$i++){
        $($result.Player[$i]) + ' <' + $($result.Email[$i]) + '>' 
    }
}

