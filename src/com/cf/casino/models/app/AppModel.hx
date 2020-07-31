package com.cf.casino.models.app;

import com.domwires.core.mvc.model.AbstractModel;
import haxe.ds.ReadOnlyArray;

@:keep
class AppModel extends AbstractModel implements IAppModel
{
    public var freeGamesCount(get, never):Int;
    public var roundEnd(get, never):Bool;
    public var totalWin(get, never):Float;
    public var roundTotalWin(get, never):Float;
    public var autoPlay(get, never):Bool;
    public var fastPlay(get, never):Bool;
    public var betAmount(get, never):Int;
    public var betValue(get, never):Float;
    public var totalBetValue(get, never):Float;
    public var winThreshold(get, never):Float;
    public var isBigWin(get, never):Bool;
    public var replacementIdList(get, never):ReadOnlyArray<Int>;
    public var uiAutoPlayEnabled(get, never):Bool;

    private var _freeGamesCount:Int;
    private var _roundEnd:Bool;
    private var _totalWin:Float;
    private var _roundTotalWin:Float;
    private var _autoPlay:Bool;
    private var _fastPlay:Bool;
    private var _betAmount:Int;
    private var _betValue:Float;
    private var _totalBetValue:Float;
    private var _replacementIdList:Array<Int>;
    private var _uiAutoPlayEnabled:Bool;


    public function setBetAmount(value:Int):IAppModel
    {
        _betAmount = value;

        dispatchMessage(AppModelMessageType.BetAmountUpdated);

        return this;
    }

    public function setBetValue(value:Float):IAppModel
    {
        _betValue = value;

        dispatchMessage(AppModelMessageType.BetValueUpdated);

        return this;
    }

    public function setTotalBetValue(value:Float):IAppModel
    {
        _totalBetValue = value;

        dispatchMessage(AppModelMessageType.TotalBetValueUpdated);

        return this;
    }

    public function setTotalWin(value:Float):IAppModel
    {
        _totalWin = value;

        dispatchMessage(AppModelMessageType.TotalWinUpdated);

        return this;
    }

    public function setRoundTotalWin(value:Float):IAppModel
    {
        _roundTotalWin = value;

        dispatchMessage(AppModelMessageType.RoundTotalWinUpdated);

        return this;
    }

    public function setAutoPlay(value:Bool):IAppModel
    {
        _autoPlay = value;

        dispatchMessage(AppModelMessageType.AutoPlayUpdated);

        return this;
    }

    public function setFastPlay(value:Bool):IAppModel
    {
        _fastPlay = value;

        dispatchMessage(AppModelMessageType.FastPlayUpdated);

        return this;
    }

    public function setFreeGamesCount(value:Int):IAppModel
    {
        _freeGamesCount = value;

        dispatchMessage(AppModelMessageType.FreeGamesCountUpdated);

        return this;
    }

    public function setIsRoundEnd(value:Bool):IAppModel
    {
        _roundEnd = value;

        dispatchMessage(AppModelMessageType.RoundEndUpdated);

        return this;
    }

    public function setReplacementIdList(value:Array<Int>):IAppModel
    {
        _replacementIdList = value;

        dispatchMessage(AppModelMessageType.ReplacementIdListUpdated);

        return this;
    }

    public function setUiAutoPlayEnabled(value:Bool):IAppModel
    {
        _uiAutoPlayEnabled = value;
        _autoPlay = value;

        dispatchMessage(AppModelMessageType.UiAutoPlayEnabledUpdated);

        return this;
    }

    private function get_freeGamesCount():Int
    {
        return _freeGamesCount;
    }

    private function get_roundEnd():Bool
    {
        return _roundEnd;
    }

    private function get_totalWin():Float
    {
        return _totalWin;
    }

    private function get_roundTotalWin():Float
    {
        return _roundTotalWin;
    }

    private function get_autoPlay():Bool
    {
        return _autoPlay;
    }

    private function get_fastPlay():Bool
    {
        return _fastPlay;
    }

    private function get_betAmount():Int
    {
        return _betAmount;
    }

    private function get_betValue():Float
    {
        return _betValue;
    }

    private function get_winThreshold():Float
    {
        return _totalWin / (_betAmount * _betValue);
    }

    private function get_isBigWin():Bool
    {
        return winThreshold >= 10;
    }

    private function get_replacementIdList():ReadOnlyArray<Int>
    {
        return _replacementIdList;
    }

    private function get_totalBetValue():Float
    {
        return _totalBetValue;
    }

    private function get_uiAutoPlayEnabled():Bool
    {
        return _uiAutoPlayEnabled;
    }
}

enum AppModelMessageType
{
    BetAmountUpdated;
    BetValueUpdated;
    TotalBetValueUpdated;
    TotalWinUpdated;
    RoundTotalWinUpdated;
    AutoPlayUpdated;
    FastPlayUpdated;
    FreeGamesCountUpdated;
    RoundEndUpdated;
    ReplacementIdListUpdated;
    UiAutoPlayEnabledUpdated;
}
