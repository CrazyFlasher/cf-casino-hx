package com.cf.slot.models.reels;

import com.cf.slot.models.reels.singleReel.ISingleReelModelImmutable;
import com.domwires.core.mvc.model.IModelContainerImmutable;
import haxe.ds.ReadOnlyArray;

interface IReelsModelImmutable extends IModelContainerImmutable
{
    var singleReelModelListImmutable(get, never):ReadOnlyArray<ISingleReelModelImmutable>;
    var scatterCount(get, never):Int;

    function getSymbolCount(id:Int):Int;
    function hasWildOnNextReels(reelIndex:Int):Bool;
    function hasWilds():Bool;

    function getReelByIndexImmutable(index:Int):ISingleReelModelImmutable;
}
