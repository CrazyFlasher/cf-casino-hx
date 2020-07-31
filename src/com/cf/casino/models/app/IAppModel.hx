package com.cf.casino.models.app;

import com.domwires.core.mvc.model.IModel;

interface IAppModel extends IAppModelImmutable extends IModel
{
    function setFreeGamesCount(value:Int):IAppModel;
    function setIsRoundEnd(value:Bool):IAppModel;
    function setTotalWin(value:Float):IAppModel;
    function setRoundTotalWin(value:Float):IAppModel;
    function setAutoPlay(value:Bool):IAppModel;
    function setFastPlay(value:Bool):IAppModel;
    function setBetAmount(value:Int):IAppModel;
    function setBetValue(value:Float):IAppModel;
    function setTotalBetValue(value:Float):IAppModel;
    function setReplacementIdList(value:Array<Int>):IAppModel;
    function setUiAutoPlayEnabled(value:Bool):IAppModel;
}