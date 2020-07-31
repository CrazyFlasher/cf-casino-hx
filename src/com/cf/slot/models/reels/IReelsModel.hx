package com.cf.slot.models.reels;

import com.cf.slot.models.reels.singleReel.ISingleReelModel;
import com.domwires.core.mvc.model.IModelContainer;

interface IReelsModel extends IReelsModelImmutable extends IModelContainer
{
    function populate(baseGameValues:Array<Array<Int>>, freeGameValues:Array<Array<Int>>):IReelsModel;
    function getReelByIndex(index:Int):ISingleReelModel;
    function update(vo:ReelsVo):IReelsModel;
}
