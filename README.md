# New-MerakiVPN
A PowerShell 4.0 approach to deploying Meraki Client VPN

#Requirements
- PowerShell 4.0+
- Administrator rights 
	-  _you can set this to be a single-user mode by removing the -AllUserConnection flags_

#Notes
This should take care of most Meraki VPN deployment scenarios.
If split tunneling isnt desired; simply set the flag in the XML file to false instead.

Enjoy
[http://i-py.com/meraki-vpn-enterprise-deployment-part-final/](http://i-py.com/meraki-vpn-enterprise-deployment-part-final/)