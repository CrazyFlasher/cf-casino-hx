package com.cf.slot.models.reels.singleReel.symbol;

import com.cf.casino.models.AbstractVo;

class SymbolVo extends AbstractVo
{
    public var id(get, set):Int;

    private var _id:Int = 0;

    private function get_id():Int
    {
        return _id;
    }

    private function set_id(value:Int):Int
    {
        return _id = value;
    }
}
