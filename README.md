# eap1-exchangelib

A first experience of an ObjectScript developper with embedded python.

# Proof of concept of an exchange adaptor

Load the package Grongier

Go to production

Open Grongier.Production

- email = your mail (example : guillaume.rongier@intersystems.com)

Create a Credential with :
- user = AD user (example : ISCINTERNAL/grongier)
- password = ...

To work, you have to be on the vpn.

# FAQ

## Why this demo ?

In France, 90% of data platform customer use the interoperability framework.

10% use IRIS/Caché/Ensemble as a pure database.

No one use, cos only applications. So, it was natural for me to test embedded python in the interoperability framework.

## Why an adapter ?

The interoperability frameworks is always missing connectors and IMAP is a long standing request that customers ask even before I start working on InterSystems technologies (2013).

## How this adaptor works ?

I use a python library called [exchangelib](https://github.com/ecederstrand/exchangelib).

I overload the callback OnInit to import this lib and configure it.

```objectscript
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
        If '$IsObject(..%CredentialsObj) Do ..CredentialsSet(..Credentials) If '$IsObject(..%CredentialsObj) { Set sc=$$$EnsError($$$EnsErrNoCredentials,..Credentials) Quit }
        //Build credential
        Set args = { "username": (..%CredentialsObj.Username) , "password": (..%CredentialsObj.Password) }
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
```

Then in OnTask, I call a python method who fetch unread messages.

```python
    import iris
    for item in self.account.inbox.filter(is_read=False).order_by('-datetime_received')[:100]:
        #print(item.subject, item.body, item.attachments)
        mail = iris.cls("Grongier.ExchangeLib.Mail")
        mail.Subject = item.subject
        mail.Body = item.body.__str__()
        self.BusinessHost.ProcessInput(mail)
```

**Here I don't know if it's a good behavior to "import iris" lib each time ?**

## Why don't you use %Net.MailMessage

I have built an ObjectScript mail object because Body in %Net.MailMessage is a Stream.

Stream doesn't work yet in embedded python, in fact, if i do :

```python
mail = iris.cls("%Net.MailMessage")
```

Property TextData doesn't exist in python world.

### SOLVED :

```python
mail = iris.cls("%Net.MailMessage")
```

is not equal to

```python
mail = iris.cls("%Net.MailMessage")._New()
```

iris.cls() returns the IRIS class not an instance of the class.  It's the equivalent of doing ##class() 


## What was a good experience ?

* It's convenient to use named args in python methods with the json format.
* The mix ObjectScript/python is impressive. 
  * Very pleasant for an ObjectScript developer.
  * iris.cls in python is great

## What can be improve ?

* ##class(%SYS.Python).Install doesn't seem to use cache, it's always reinstalling stuff
* ##class(%SYS.Python).Import return just 0 in case of error is it enough ?
* Stream property is not supported

## TL;TR

Overall, this is a great feature. I don't understand how we have been able to live without it ?

## What do you wish ?

* One day, we don't have to use ObjectScript anymore.
* Have persistent object in pure python
* Save python class and libs in the code database as we do with ObjectScript
  * Bring code to data, not data to code
  * This mantra can be very powerfull to sale IRIS (I use it even now with ObjectScript)
    * Now days, we (humanity) produce more and more datas each days.
    * It's more cost-effective do bring code to data because code is lighter than datas.
* The full interoperability framework is available in pure python (Ens.*)
  * I'm not a python expert, but I've heard that it's difficult to use parallelization and multi-threading in python.
  * Interoperability frameworks bring this possibility easily with pools.
  * It's a great framework to organize a project and see logs in trace

# Todo 

- [x] Use interoperabilty Credential
- [ ] Clean up code
- [ ] Write documentation
