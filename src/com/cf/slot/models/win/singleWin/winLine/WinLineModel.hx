package com.cf.slot.models.win.singleWin.winLine;

import com.domwires.core.mvc.model.AbstractModel;

class WinLineModel extends AbstractModel implements IWinLineModel
{
    private var vo:WinLineVo;

    public var positionIdList(get, never):Array<Int>;
    public var id(get, never):Int;
    public var hasWild(get, never):Bool;
    public var hasScatter(get, never):Bool;

    public function update(vo:WinLineVo):IWinLineModel
    {
        this.vo = vo;

        return this;
    }

    private function get_hasWild():Bool
    {
        return vo.hasWild;
    }

    private function get_hasScatter():Bool
    {
        return vo.hasScatter;
    }

    private function get_positionIdList():Array<Int>
    {
        return vo.positionIdList;
    }

    private function get_id():Int
    {
        return vo.id;
    }
}
