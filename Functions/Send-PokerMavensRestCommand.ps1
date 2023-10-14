
Function Send-PokerMavensRestCommand {
    <#
.SYNOPSIS
Sends a REST command to a Poker Mavens server.

.DESCRIPTION
The Send-PokerMavensRestCommand function sends a REST command to a Poker Mavens server using the specified parameters.

.PARAMETER Protocol
Specifies the protocol to use for the REST request. The default value is 'https'.

.PARAMETER ServerName
Specifies the name of the Poker Mavens server to send the REST request to.

.PARAMETER Port
Specifies the port number to use for the REST request. The default value is 443.

.PARAMETER Password
Specifies the password to use for the REST request.

.PARAMETER ApiPath
Specifies the API path to use for the REST request.

.PARAMETER CommandSet
Specifies the command set to use for the REST request.

.PARAMETER Method
Specifies the HTTP method to use for the REST request. The default value is 'Get'.

.EXAMPLE
Send-PokerMavensRestCommand -ServerName 'poker.ms' -Password 'NotTheRealPassword' -ApiPath 'api' -CommandSet 'SystemLobbyMessage&Message=TestMessage'

Sends a REST command to the 'poker.ms' server with the 'SystemLobbyMessage&Message=TestMessage' command set.

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
        $ApiPath,
        [Parameter(Mandatory = $true)]
        [string]
        $CommandSet = 'SystemLobbyMessage&Message=TestMessage',
        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Post', 'Put', 'Delete')]
        [string]
        $Method = 'Get'
    )

    $uri = "$Protocol`://$ServerName`:$Port/$ApiPath`?Password=$Password&JSON=Yes&Command=$CommandSet"

    Invoke-RestMethod -Method $Method -Uri $uri
}


