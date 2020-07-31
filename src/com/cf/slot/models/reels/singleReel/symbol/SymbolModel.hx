package com.cf.slot.models.reels.singleReel.symbol;

import com.cf.slot.config.ISlotConfig;
import com.domwires.core.mvc.model.AbstractModel;
import com.domwires.core.utils.ArrayUtils;

@:keep
class SymbolModel extends AbstractModel implements ISymbolModel
{
    @Inject
    private var config:ISlotConfig;

    public var id(get, never):Int;
    public var isWild(get, never):Bool;
    public var isScatter(get, never):Bool;
    public var vo(get, never):SymbolVo;

    private var _isWild:Bool;
    private var _isScatter:Bool;
    private var _id:Int = 0;
    private var _vo:SymbolVo;

    private var _wonOnLineIdList:Array<Int>;
    private var _hasWinOnAnyLine:Bool;

    public function update(vo:SymbolVo):ISymbolModel
    {
        _vo = vo;

        _id = vo.id;

        _hasWinOnAnyLine = false;

        if (_wonOnLineIdList != null)
        {
            ArrayUtils.clear(_wonOnLineIdList);
        }

        _isWild = _id == config.wildSymbolId;
        _isScatter = _id == config.scatterSymbolId;

        return this;
    }

    public function addWin(wonOnLineId:Int = -1):ISymbolModel
    {
        _hasWinOnAnyLine = true;

        if (_wonOnLineIdList == null)
        {
            _wonOnLineIdList = [];
        }

        _wonOnLineIdList.push(wonOnLineId);

        return this;
    }

    public function hasWinOnAnyLine():Bool
    {
        return _hasWinOnAnyLine;
    }

    public function hasWin(lineId:Int = -1):Bool
    {
        if (_wonOnLineIdList == null)
        {
            return false;
        }

        for (wonOnLineId in _wonOnLineIdList)
        {
            if (wonOnLineId == lineId)
            {
                return true;
            }
        }

        return false;
    }

    private function get_id():Int
    {
        return _id;
    }

    private function get_isScatter():Bool
    {
        return _isScatter;
    }

    private function get_isWild():Bool
    {
        return _isWild;
    }

    private function get_vo():SymbolVo
    {
        return _vo;
    }
}
