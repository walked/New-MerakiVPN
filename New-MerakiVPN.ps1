$xdoc = New-Object System.Xml.XmlDocument
$file = Resolve-Path("$PSScriptRoot\connection.xml")
$xdoc.Load($file)

$vpnName = $xdoc.connection.vpn.name
$vpnEndpoint = $xdoc.connection.vpn.endpoint
$vpnPsk = $xdoc.connection.vpn.psk

[Boolean]$splitTunnel = [System.Convert]::ToBoolean($xdoc.connection.vpn.tunnel)

function Main
{
    <#
        .SYNOPSIS
        Main function for MerakiVPN.ps1
        .DESCRIPTION
        Due to the sequential loading of PowerShell this function encapsulates the main program logic and is called at the very end of the script file to kick it off.

    #>
	if ((Test-VpnNameAvailable -nameToTest $vpnName) -eq $true)
	{
		if ($splitTunnel)
		{
			Add-VpnConnection -L2tpPsk $vpnPsk -name $vpnName -ServerAddress $vpnEndpoint -AllUserConnection -AuthenticationMethod Pap -TunnelType L2tp -SplitTunneling -Force
			
			foreach ($sn in $xdoc.connection.subnets.ChildNodes)
			{
				Add-VpnConnectionRoute -AllUserConnection -ConnectionName $vpnName -DestinationPrefix $sn.network
			}
		}
		
		else
		{
			Add-VpnConnection -L2tpPsk $vpnPsk -name $vpnName -ServerAddress $vpnEndpoint -AllUserConnection -AuthenticationMethod Pap -TunnelType L2tp -Force
		}
		
	}
}




function Test-VpnNameAvailable
{
    <#
        .SYNOPSIS
        Test-VpnNameAvailable will test if the proposed VPN Name is available for an adapter.
        .DESCRIPTION
        The command Add-VppnConnection requires the -name specified to be not in use. This will test whether or not the VPN name is used by any other profile.
        .EXAMPLE
        Test-VpnNameAvailable "TestName"
        Will return true if it's available, and false if not.
    #>
	param
	(
		[Parameter(Position = 0, mandatory = $true)]
		[String]$nameToTest
	)
	
	$vpnTest = Get-VpnConnection -AllUserConnection -Name $nameToTest -ErrorAction SilentlyContinue
	if ($vpnTest -ne $null)
	{
		return $false
	}
	else
	{
		return $true
	}
}


Main