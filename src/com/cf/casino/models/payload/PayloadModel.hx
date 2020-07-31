package com.cf.casino.models.payload;

import com.cf.devkit.trace.Trace;
import com.domwires.core.mvc.model.AbstractModel;

@:keep
class PayloadModel extends AbstractModel implements IPayloadModel
{
    public var value(get, never):Dynamic;

    private var _value:Dynamic;

    public function setValue(value:Dynamic, notify:Bool = true):IPayloadModel
    {
        trace("setValue " + value, Trace.INFO);

        _value = value;

        if (notify)
        {
            dispatchMessage(PayloadModelMessageType.ValueUpdated);
        }

        return this;
    }

    private function get_value():Dynamic
    {
        return _value;
    }
}

enum PayloadModelMessageType
{
    ValueUpdated;
}
