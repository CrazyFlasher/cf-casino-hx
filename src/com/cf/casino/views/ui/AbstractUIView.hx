package com.cf.casino.views.ui;

import haxe.io.Error;
import openfl.geom.Rectangle;

class AbstractUIView extends View implements IUIView
{
    public var sfxVolume(get, never):Float;
    public var musicVolume(get, never):Float;
    public var fastPlay(get, never):Bool;
    public var autoPlay(get, never):Bool;

    @Inject("safeArea")
    private var safeArea:Rectangle;

    public var data(get, never):Dynamic;

    private var _data:Dynamic;

    private function dispatch(messageType:EnumValue, data:Dynamic):Void
    {
        _data = data;

        dispatchMessage(messageType);
    }

    private function get_data():Dynamic
    {
        return _data;
    }

    private function get_sfxVolume():Float
    {
        throw Error.Custom("Override!");
    }

    private function get_musicVolume():Float
    {
        throw Error.Custom("Override!");
    }

    private function get_fastPlay():Bool
    {
        throw Error.Custom("Override!");
    }

    private function get_autoPlay():Bool
    {
        throw Error.Custom("Override!");
    }

    public function showPlayButton(value:Bool):Void
    {

    }

    public function showBetButton(value:Bool):Void
    {

    }

    public function updateWinValue(value:Float):Void
    {

    }

    public function updateBetMultiplier(value:Float):Void
    {

    }

    public function updateFreePlaysValue(value:Float):Void
    {

    }
}
