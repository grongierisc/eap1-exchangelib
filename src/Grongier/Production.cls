Class Grongier.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Grongier.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Grongier.ExchangeLib.DemoService" Category="" ClassName="Grongier.ExchangeLib.DemoService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="email">guillaume.rongier@intersystems.com</Setting>
  </Item>
</Production>
}

}
