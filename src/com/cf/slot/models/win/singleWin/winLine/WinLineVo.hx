package com.cf.slot.models.win.singleWin.winLine;

import com.cf.slot.config.ISlotConfig;
import com.cf.casino.models.AbstractVo;
import com.domwires.core.utils.ArrayUtils;

class WinLineVo extends AbstractVo
{
    @Inject
    private var config:ISlotConfig;

    private var _id:Int;
    private var positionIdListJsonArray:Array<Dynamic>;
    private var display:Array<Dynamic>;

    public var hasWild(get, never):Bool;
    public var hasScatter(get, never):Bool;

    private var _hasWild:Bool;
    private var _hasScatter:Bool;

    public var positionIdList(get, never):Array<Int>;
    public var id(get, never):Int;

    private var _positionIdList:Array<Int> = [];
    private var _count:Int;

    public function update(display:Dynamic, positionIdListJsonArray:Array<Dynamic>, id:Int):Void
    {
        this.positionIdListJsonArray = positionIdListJsonArray;
        this.display = display;
        _id = id;

        ArrayUtils.clear(_positionIdList);

        for (positionId in positionIdListJsonArray)
        {
            _positionIdList.push(positionId);
        }

        _hasWild = hasSymbolId(config.wildSymbolId);
        _hasScatter = hasSymbolId(config.scatterSymbolId);
    }

    private function hasSymbolId(symbolId:Int):Bool
    {
        for (i in 0..._positionIdList.length)
        {
            if (display[i][_positionIdList[i]] == symbolId)
            {
                return true;
            }
        }

        return false;
    }

    private function get_positionIdList():Array<Int>
    {
        return _positionIdList;
    }

    private function get_id():Int
    {
        return _id;
    }

    private function get_hasWild():Bool
    {
        return _hasWild;
    }

    private function get_hasScatter():Bool
    {
        return _hasScatter;
    }
}
