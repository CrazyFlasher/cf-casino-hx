package com.cf.slot.config;

import com.cf.casino.config.CasinoConfig;
import haxe.io.Error;

//Keep this and super immutable
class SlotConfig extends CasinoConfig implements ISlotConfig
{
    public var extraAnticipation(get, never):ExtraAnticipationVo;
    public var reelsCount(get, never):Int;
    public var symbolsOnReelCount(get, never):Int;
    public var totalSymbolCount(get, never):Int;
    public var scatterSymbolId(get, never):Int;
    public var wildSymbolId(get, never):Int;
    public var skipBigWinAllowed(get, never):Bool;
    public var skipReelsAnticipationAllowed(get, never):Bool;
    public var skipExtraAnticipationAllowed(get, never):Bool;
    public var skipWinsHighLightAllowed(get, never):Bool;
    public var preStartReelDisplacementFactor(get, never):Float;
    public var preStopReelDisplacementFactor(get, never):Float;

    public var maxBlurOpacity(get, never):Float;
    public var spinDelay(get, never):Float;
    public var preSpinTime(get, never):Float;
    public var preStopTime(get, never):Float;
    public var accelerateSpinTime(get, never):Float;
    public var spinLoopTime(get, never):Float;
    public var spinStopTime(get, never):Float;
    public var loopCount(get, never):Int;

    private function get_wildSymbolId():Int
    {
        return -1;
    }

    private function get_scatterSymbolId():Int
    {
        return -1;
    }

    private function get_reelsCount():Int
    {
        throw Error.Custom("Override!");
    }

    private function get_symbolsOnReelCount():Int
    {
        throw Error.Custom("Override!");
    }

    private function get_totalSymbolCount():Int
    {
        throw Error.Custom("Override!");
    }

    private function get_spinDelay():Float
    {
        return 0.1;
    }

    private function get_preSpinTime():Float
    {
        return 0.2;
    }

    private function get_accelerateSpinTime():Float
    {
        return 0.025;
    }

    private function get_spinLoopTime():Float
    {
        return 0.05;
    }

    private function get_spinStopTime():Float
    {
        return 0.2;
    }

    private function get_loopCount():Int
    {
        return 6;
    }

    private function get_maxBlurOpacity():Float
    {
        return 1;
    }

    private function get_preStopTime():Float
    {
        return 0.1;
    }

    private function get_extraAnticipation():ExtraAnticipationVo
    {
        return null;
    }

    private function get_skipBigWinAllowed():Bool
    {
        return true;
    }

    private function get_skipReelsAnticipationAllowed():Bool
    {
        return true;
    }

    private function get_skipExtraAnticipationAllowed():Bool
    {
        return true;
    }

    private function get_skipWinsHighLightAllowed():Bool
    {
        return true;
    }

    private function get_preStartReelDisplacementFactor():Float
    {
        return 0.25;
    }

    private function get_preStopReelDisplacementFactor():Float
    {
        return 0.0625;
    }
}
