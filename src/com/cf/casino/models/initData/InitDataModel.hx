package com.cf.casino.models.initData;

import com.domwires.core.mvc.model.AbstractModel;

@:keep
class InitDataModel extends AbstractModel implements IInitDataModel
{
    public var rawData(get, never):Dynamic;

    private var _rawData:Dynamic;

    public function populate(value:Dynamic):IInitDataModel
    {
        updateRawData(value);

        dispatchMessage(InitDataModelMessageType.Populated);

        return this;
    }

    private function updateRawData(value:Dynamic):Void
    {
        _rawData = value;
    }

    private function get_rawData():Dynamic
    {
        return _rawData;
    }
}

enum InitDataModelMessageType
{
    Populated;
}
