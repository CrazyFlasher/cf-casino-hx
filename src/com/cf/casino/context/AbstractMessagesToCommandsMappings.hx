package com.cf.casino.context;

import com.domwires.core.common.AbstractDisposable;
import com.domwires.core.mvc.command.ICommandMapper;
import com.domwires.core.mvc.command.MappingConfig;
import com.domwires.core.mvc.command.MappingConfigList;
import haxe.io.Error;

class AbstractMessagesToCommandsMappings extends AbstractDisposable
{
    @Inject
    private var cm:ICommandMapper;

    @PostConstruct
    private function init():Void
    {
        cm.setMergeMessageDataAndMappingData(true);

        mapMessagesToCommands();
    }

    override public function dispose():Void
    {
        cm.dispose();
        cm = null;

        super.dispose();
    }

    public function clear():Void
    {
        cm.clear();
    }

    private function mapMessagesToCommands():Void
    {
        throw Error.Custom("Override!");
    }

    private function map(messageType:EnumValue, commandClass:Class<Dynamic>, data:Dynamic = null,
                         stopOnExecute:Bool = true, once:Bool = false):MappingConfig
    {
        return cm.map(messageType, commandClass, data, once, stopOnExecute);
    }

    private function map1(messageType:EnumValue, commandClassList:Array<Class<Dynamic>>, data:Dynamic = null,
                         stopOnExecute:Bool = true, once:Bool = false):MappingConfigList
    {
        return cm.map1(messageType, commandClassList, data, once, stopOnExecute);
    }

    private function map2(messageTypeList:Array<EnumValue>, commandClass:Class<Dynamic>, data:Dynamic = null,
                         stopOnExecute:Bool = true, once:Bool = false):MappingConfigList
    {
        return cm.map2(messageTypeList, commandClass, data, once, stopOnExecute);
    }

    private function map3(messageTypeList:Array<EnumValue>, commandClassList:Array<Class<Dynamic>>, data:Dynamic = null,
                          stopOnExecute:Bool = true, once:Bool = false):MappingConfigList
    {
        return cm.map3(messageTypeList, commandClassList, data, once, stopOnExecute);
    }
}
