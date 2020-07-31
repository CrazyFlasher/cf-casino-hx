package com.cf.slot.models.reels.singleReel;

import com.cf.slot.models.reels.singleReel.symbol.ISymbolModelImmutable;
import com.domwires.core.mvc.model.IModelContainerImmutable;
import haxe.ds.ReadOnlyArray;

interface ISingleReelModelImmutable extends IModelContainerImmutable
{
    var index(get, never):Int;
    var symbolModelListImmutable(get, never):ReadOnlyArray<ISymbolModelImmutable>;
    var baseGameValues(get, never):Array<Int>;
    var freeGameValues(get, never):Array<Int>;
    var scatterCount(get, never):Int;

    function getSymbolCount(id:Int):Int;
    function hasWilds():Bool;
    function hasScatters():Bool;

    function getPosition(symbolIdListString:String, isFreeGame:Bool):Int;
    function getSymbolIdList(position:Int, isFreeGame:Bool):Array<Int>;
}
