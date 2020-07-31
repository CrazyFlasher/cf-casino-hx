package com.cf.slot.config;

import com.cf.casino.config.ICasinoConfig;

interface ISlotConfig extends ICasinoConfig
{
    /**
    * Additional reel anticipation setting.
    **/
    var extraAnticipation(get, never):ExtraAnticipationVo;

    /**
    * Id of scatter (bonus) symbol.
    **/
    var scatterSymbolId(get, never):Int;

    /**
    * Id of wirld symbol.
    **/
    var wildSymbolId(get, never):Int;

    /**
    * Total reels of slotmachine.
    **/
    var reelsCount(get, never):Int;

    /**
    * Symbols count on one reel.
    **/
    var symbolsOnReelCount(get, never):Int;

    /**
    * Total symbols in the game.
    **/
    var totalSymbolCount(get, never):Int;

    /**
    * Maximum blur opacity (0.0 - 1.0).
    **/
    var maxBlurOpacity(get, never):Float;

    /**
    * Delay for each reel before start spinning (except the frist one).
    **/
    var spinDelay(get, never):Float;

    /**
    * Duration, while reel goes up, before going down and spin.
    * Ignored, if fast play option is on.
    **/
    var preSpinTime(get, never):Float;

    /**
    * Duration, while reel goes down, before stop..
    * Ignored, if fast play option is on.
    **/
    var preStopTime(get, never):Float;

    /**
    * Duration, while reels is accelerating, when spin is started.
    **/
    var accelerateSpinTime(get, never):Float;

    /**
    * Duration, while symbols passes one cell of reel.
    **/
    var spinLoopTime(get, never):Float;

    /**
    * Duration of last loop.
    * Ignored, if fast play option is off.
    **/
    var spinStopTime(get, never):Float;

    /**
    * How much reel will pass until stopped.
    **/
    var loopCount(get, never):Int;

    /**
    * Allow to skip big win.
    **/
    var skipBigWinAllowed(get, never):Bool;

    /**
    * Allow skip reels anticipation.
    **/
    var skipReelsAnticipationAllowed(get, never):Bool;

    /**
    * Allow skip extra anticipation.
    **/
    var skipExtraAnticipationAllowed(get, never):Bool;

    /**
    * Allow skip wins highlighting.
    **/
    var skipWinsHighLightAllowed(get, never):Bool;

    /**
    * How far reels will be moved up before goind down (1 - symbol height).
    **/
    var preStartReelDisplacementFactor(get, never):Float;

    /**
    * How far reels will be moved dowm before stop (1 - symbol height).
    **/
    var preStopReelDisplacementFactor(get, never):Float;
}
