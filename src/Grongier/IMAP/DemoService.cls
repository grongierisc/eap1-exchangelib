Class Grongier.IMAP.DemoService Extends Ens.BusinessService
{

Parameter ADAPTER = "Grongier.IMAP.InboundAdapter";

Method OnProcessInput(pMailMessage As Grongier.IMAP.Mail, pOutput As %RegisteredObject) As %Status
{
	set tSC = $$$OK
	$$$LOGINFO(pMailMessage.Subject)
    $$$LOGINFO(pMailMessage.Body)
	
	Quit tSC
}

}
