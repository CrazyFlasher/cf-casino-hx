package com.cf.casino.views.ui;

interface IUIView extends IView
{
    var data(get, never):Dynamic;
    var sfxVolume(get, never):Float;
    var musicVolume(get, never):Float;
    var fastPlay(get, never):Bool;
    var autoPlay(get, never):Bool;

    function showPlayButton(value:Bool):Void;
    function showBetButton(value:Bool):Void;
    function updateWinValue(value:Float):Void;
    function updateBetMultiplier(value:Float):Void;
    function updateFreePlaysValue(value:Float):Void;
}
