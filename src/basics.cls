Class basics Extends %RegisteredObject
{
/* Example of how Classes in ObjectScript interact with Python */


/* Accessing other properties in this class from Python */
Property VariableMessage As %String [ InitialExpression = "How are you?"];
// Can we access Properties?
Method Test2a() As %Numeric [ Language = python ] 
{
    foo = self.VariableMessage
    return (foo=="How are you?")
}
// Can we update Properties?
Method Test2b() As %Numeric [ Language = python ] 
{
    self.VariableMessage = "Test2b"
    foo = self.VariableMessage
    return (foo=="Test2b")
}



/* Example of how to manipulate globals in Python */
Method SetTestGlobal(val as %Numeric)
{
    SET ^Test=val
    quit $$$OK
}
Method GetTestGlobal() as %Numeric
{
    quit ^Test
}
Method WriteTestGlobal()
{
    write !, "Hello there", !
    write ^Test
    quit $$$OK
}


// Can we read a global that was set in ObjectScript from Python?
Method Test1a() As %Numeric [ Language = python ] 
{
    import iris

    foo = iris.gref("^Test")
    return foo.get()==42
}
// Can we read a global that was set in ObjectScript from Python?
Method Test1b() As %Numeric [ Language = python ] 
{
    self.WriteTestGlobal()
    return 1
}

/// Example of how to make SQL calls from Python
Method Sql() As %Numeric [ Language = python ]
{
    import iris

    stmt = iris.sql.prepare("select Name, Super, TimeCreated from %Dictionary.ClassDefinition WHERE Name %STARTSWITH ?")
    rs = stmt.execute("%Net.")
    for idx, row in enumerate(rs):
        print(f"[{idx}]: {row}")
    return 1
}


}
