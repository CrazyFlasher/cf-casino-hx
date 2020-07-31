package com.cf.casino.models.texts;

import com.domwires.core.mvc.model.AbstractModel;

class TextsModel extends AbstractModel implements ITextsModel
{
    private var map:Map<String, String> = new Map<String, String>();

    public function get(key:String):String
    {
        if (!map.exists(key))
        {
            trace("Warning: '" + key + "' is missing", Trace.WARNING);

            return key;
        }

        return map.get(key);
    }

    public function set(key:String, value:String):ITextsModel
    {
        map.set(key, value);

        return this;
    }

    public function clear():ITextsModel
    {
        map.clear();

        return this;
    }

    override public function dispose():Void
    {
        clear();

        map = null;

        super.dispose();
    }
}
