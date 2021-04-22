Class Grongier.ExchangeLib.DemoService Extends Ens.BusinessService
{

Parameter ADAPTER = "Grongier.ExchangeLib.InboundAdapter";

Method OnProcessInput(pMailMessage As Grongier.ExchangeLib.Mail, pOutput As %RegisteredObject) As %Status
{
	set tSC = $$$OK
	$$$LOGINFO(pMailMessage.Subject)
    $$$LOGINFO(pMailMessage.Body)
	
	Quit tSC
}

}
