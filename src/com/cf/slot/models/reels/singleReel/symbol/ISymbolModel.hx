package com.cf.slot.models.reels.singleReel.symbol;

import com.domwires.core.mvc.model.IModel;

interface ISymbolModel extends ISymbolModelImmutable extends IModel
{
    function addWin(wonOnLineId:Int = -1):ISymbolModel;
    function update(vo:SymbolVo):ISymbolModel;
}
