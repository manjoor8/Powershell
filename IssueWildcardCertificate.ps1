#Install Posh-ACME if not already installed
#Install-Module -Name Posh-ACME
New-PACertificate *.yourdomain.com -AcceptTOS -Contact <your-email> -DnsPlugin AcmeDns -PluginArgs @{ACMEServer='auth.acme-dns.io'} -Install -PfxPass <pfx-Password>
#It will prompt you to create CNMAE record. Create the record and hit any key after 2 minutes. Wait for few minutes
#The pfx will be located in the folder %LOCALAPPDATA%\Posh-ACME.
