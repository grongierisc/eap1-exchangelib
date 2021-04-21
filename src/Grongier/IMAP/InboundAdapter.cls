/// Description
Class Grongier.IMAP.InboundAdapter Extends Ens.InboundAdapter
{

/// Description
Property exchangelib As %SYS.Python;

/// Description
Property credential As %SYS.Python;

/// Description
Property account As %SYS.Python;

/// Description
Property user As %String;

/// Description
Property email As %String;

/// Description
Property password As %String;

Parameter SETTINGS = "user,email,password";

Method OnTask() As %Status
{
    set tSC = $$$OK

    Try {
        Do ..OnTaskPython()
	    Set ..BusinessHost.%WaitForNextCallInterval=1
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

	Quit tSC
}

/// Description
Method OnTaskPython() As %Status [ Language = python ]
{
    import iris
    for item in self.account.inbox.filter(is_read=False).order_by('-datetime_received')[:100]:
        #print(item.subject, item.body, item.attachments)
        mail = iris.cls("Grongier.IMAP.Mail")
        mail.Subject = item.subject
        mail.Body = item.body.__str__()
        self.BusinessHost.ProcessInput(mail)
}

Method OnInit() As %Status
{
    Set sc = $$$OK

    Try {
        //Import
        Set ..exchangelib = ##class(%SYS.Python).Import("exchangelib")
        //Can't load try to install
        if ..exchangelib = 0 {
            //Install
            Set sc =  ##class(%SYS.Python).Install("exchangelib")
            Set ..exchangelib = ##class(%SYS.Python).Import("exchangelib")
        }

        //Build credential
        Set args = { "username": (..user) , "password": (..password) }
        Set ..credential = ..exchangelib.Credentials(args...)

        //Build account
        Set args = {    "primary_smtp_address":(..email) , 
                        "credentials":(..credential), 
                        "autodiscover":(##class(%SYS.Python).True()), 
                        "access_type":(..exchangelib.DELEGATE) }
        Set ..account = ..exchangelib.Account(args...)
    }
    Catch ex {
        Set sc=ex.AsStatus()
    }
    Return sc
}

Method OnTearDown() As %Status
{
    Set sc = $$$OK
    // do something
    Return sc
}

}