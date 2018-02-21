Set-Variable mailSMTPServer -option Constant -value "";
Set-Variable mailSMTPPort 	-option Constant -value ;
Set-Variable mailUsername 	-option Constant -value "";
Set-Variable mailPassword 	-option Constant -value ""
Set-Variable mailTo 		-option Constant -value ""
Set-Variable mailSubject 	-option Constant -value ""

Set-Variable logFileAbsPath -option Constant -value "iplog.csv";

function getIp {
	$source = "http://api.ipify.org/?format=json"
    $client = new-object System.Net.WebClient
    $webpage = $client.downloadString($source)
    $lines = $webpage.split(":")
    foreach ($line in $lines) {
		if (!$line.contains("ip")) {
			$ip = (($line -replace "\""", "") -replace "}", "")
        }
    }
    return $ip
}

function sendMail{
	$ipAddress = getIp
	if($ipAddress -eq "") {
		return;
	}
		
	if(isPrevious($ipAddress)) {	
		return;
	}

	$body = $ipAddress

	$message = New-Object System.Net.Mail.MailMessage
	$message.subject = $mailSubject
	$message.body = $body
	$message.to.add($mailTo)
	$message.from = $mailUsername

	$smtp = New-Object System.Net.Mail.SmtpClient($mailSMTPServer, $mailSMTPPort);
	$smtp.EnableSSL = $true
	$smtp.Credentials = New-Object System.Net.NetworkCredential($mailUsername, $mailPassword);
	$smtp.send($message)
}

function isPrevious($newIp) {
	$outcome = $false;
	
	$lastRow = (Import-csv $logFileAbsPath)[-1];
	if ($lastRow.address -eq $newIp) {
		$outcome = $true;
	}
	
	$newRow = "$($newIp),$(Get-Date)"
	Add-Content $logFileAbsPath $newRow;
	
	return $outcome;
}

sendMail