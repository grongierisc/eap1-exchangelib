/// Description
Class Grongier.IMAP.Mail Extends %SerialObject
{

/// Description
Property Subject As %String;

/// Description
Property Body As %String;

Storage Default
{
<Data name="MailState">
<Value name="1">
<Value>Subject</Value>
</Value>
<Value name="2">
<Value>Body</Value>
</Value>
</Data>
<State>MailState</State>
<StreamLocation>^Grongier.IMAP.MailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}