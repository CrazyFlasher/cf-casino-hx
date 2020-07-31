package com.cf.casino.views.ui.impl;

import com.cf.devkit.trace.Trace;
@:keep
class JSUIView extends AbstractUIView implements IUIView
{
	override private function init():Void
	{
		super.init();

		trace("initialized!");

		//gAPI.casinoUI.addEventListener(eventName:string, callback: function, once?:boolean default false)
		UIView.addEventListener("OverlayToggle", data -> dispatch(UIViewMessageType.OverlayToggle, data));

		//eventName = LabelName + Update
		UIView.addEventListener("MusicUpdate", data -> dispatch(UIViewMessageType.MusicVolumeUpdate, data));
		UIView.addEventListener("SoundUpdate", data -> dispatch(UIViewMessageType.SoundVolumeUpdate, data));
		UIView.addEventListener("QuickspinUpdate", data -> dispatch(UIViewMessageType.QuickPlayUpdate, data));

		//skip animations, etc
		UIView.addEventListener("ScreenClick", data -> dispatch(UIViewMessageType.ScreenClick, data));
		//update collection bars, etc
		UIView.addEventListener("BetUpdate", data -> dispatch(UIViewMessageType.BetUpdate, data));
		//Pause the game when menu or overlay is opened/ unpause when closed
		UIView.addEventListener("MenuToggle", data -> dispatch(UIViewMessageType.MenuToggle, data));
		//play button click sound
		UIView.addEventListener("ButtonClick", buttonClick);
		UIView.addEventListener("fastplayUpdate", data -> dispatch(UIViewMessageType.FastPlayUpdate, data));
		UIView.addEventListener("resize", safeAreaUpdated);

		untyped __js__("document.addEventListener(\"visibilitychange\", $bind(this,this.handleVisibilityChange));");
	}

	private function handleVisibilityChange():Void
	{
		var vstate:String = untyped __js__("document.visibilityState");
		var visible:Bool = vstate.toLowerCase() == "visible";
		trace("handleVisibilityChange " + vstate);

		dispatch(UIViewMessageType.VisibilityChanged, visible);
	}

	private function safeAreaUpdated(data:Dynamic):Void
	{
		var area:Dynamic = UIView.safeArea;

		safeArea.left = area.left;
		safeArea.right = area.right;
		safeArea.top = area.top;
		safeArea.bottom = area.bottom;

		dispatch(UIViewMessageType.UIResize, data);
	}

	private function buttonClick(data:Dynamic):Void
	{
		dispatch(UIViewMessageType.ButtonClick, data);

		if (data.name == "autoplayStartButton")
		{
			dispatch(UIViewMessageType.UiAutoPlayEnabledUpdate, true);
		} else if (data.name == "stopAutoplayButton")
		{
			dispatch(UIViewMessageType.UiAutoPlayEnabledUpdate, false);
		}
	}

	override private function get_sfxVolume():Float
	{
		return roundSfxValue(UIView.settings.sound / 100);
	}

	override private function get_musicVolume():Float
	{
		return roundSfxValue(UIView.settings.music / 100);
	}

	override private function get_fastPlay():Bool
	{
		return UIView.settings.fastplay;
	}

	override private function get_autoPlay():Bool
	{
		trace("UIView.autoplay " + UIView.autoplay, Trace.INFO);

		return UIView.autoplay == null ? false : UIView.autoplay;
	}

	override public function updateWinValue(value:Float):Void
	{
		super.updateWinValue(value);

		UIView.totalWin = value;
	}

	override public function updateBetMultiplier(value:Float):Void
	{
		super.updateBetMultiplier(value);

		UIView.betMultiplier = value;
	}

	private function roundSfxValue(value:Float):Float
	{
		if (value < 0.1) value = 0;
		return value;
	}

	override public function showPlayButton(value:Bool):Void
	{
		super.showPlayButton(value);

		UIView.mode(null, {disable: {play: !value, autoplay: !value}});
	}

	override public function showBetButton(value:Bool):Void
	{
		super.showBetButton(value);

		UIView.mode(null, {disable: {bet: !value}});
	}

	override public function updateFreePlaysValue(value:Float):Void
	{
		super.updateFreePlaysValue(value);

        if (value > 0)
        {
            UIView.mode('FreeGame', {counter: {value: value}});
        } else
        {
            UIView.mode('FreeGame', false);
        }
	}

}

@:native("gAPI.casinoUI")
extern class UIView
{
	static function addEventListener(type:String, handler:Dynamic -> Void, once:Bool = false):Void;
	static var safeArea:Dynamic;
	static var settings:Settings;
	static var totalWin:Float;
	static var betMultiplier:Float;
	static var mode:Dynamic;
	static var autoplay:Bool;
}

@:native("gAPI.casinoUI.settings")
extern class Settings
{
	var sound:Int;
	var music:Int;
	var fastplay:Bool;
}

