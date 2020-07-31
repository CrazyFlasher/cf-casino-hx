package com.cf.slot.models.reels.singleReel;

import com.cf.slot.models.reels.singleReel.symbol.ISymbolModel;
import com.domwires.core.mvc.model.IModelContainer;

interface ISingleReelModel extends ISingleReelModelImmutable extends IModelContainer
{
    function populate(baseGameValues:Array<Int>, freeGameValues:Array<Int>):ISingleReelModel;
    function setIndex(value:Int):ISingleReelModel;
    function getSymbolByIndex(index:Int):ISymbolModel;
    function update(vo:SingleReelVo):ISingleReelModel;
}
