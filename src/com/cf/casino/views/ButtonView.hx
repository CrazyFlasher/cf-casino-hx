package com.cf.casino.views;

import com.cf.devkit.bundle.DisplayObjectMessageType;
import com.cf.devkit.bundle.IMovieClip;
import com.domwires.core.mvc.message.IMessage;

class ButtonView extends MovieClipView
{
    public var enabled(get, set):Bool;
    private var _enabled:Bool = true;

    public var scaleOnTouch(get, set):Float;
    private var _scaleOnTouch:Float = 0.9;

    private var initialScaleX:Float;
    private var initialScaleY:Float;

    override public function dispose():Void
    {
        _movieAssets.removeAllMessageListeners();

        super.dispose();
    }

    override private function set_movieAssets(value:IMovieClip):IMovieClip
    {
        super.set_movieAssets(value);

        _assets.alignPivot();

        initialScaleX = _movieAssets.scaleX;
        initialScaleY = _movieAssets.scaleY;

        _movieAssets.addMessageListener(DisplayObjectMessageType.TouchOver, over);
        _movieAssets.addMessageListener(DisplayObjectMessageType.TouchOut, out);
        _movieAssets.addMessageListener(DisplayObjectMessageType.TouchBegan, down);
        _movieAssets.addMessageListener(DisplayObjectMessageType.TouchEnded, up);

        //TODO: find out why it plays 3rd frame without it
        value.gotoAndStop(0);

        return value;
    }

    private function over(m:IMessage):Void
    {
        if (_movieAssets.totalFrames > 1)
        {
            _movieAssets.gotoAndStop(1);
        }
    }

    private function down(m:IMessage):Void
    {
        if (_movieAssets.totalFrames > 2)
        {
            _movieAssets.gotoAndStop(2);
        }

        _movieAssets.scaleX = _scaleOnTouch * initialScaleX;
        _movieAssets.scaleY = _scaleOnTouch * initialScaleY;
    }

    private function up(m:IMessage = null):Void
    {
        _movieAssets.gotoAndStop(0);

        _movieAssets.scaleX = initialScaleX;
        _movieAssets.scaleY = initialScaleY;
    }

    private function out(m:IMessage):Void
    {
        up();
    }

    private function get_enabled():Bool
    {
        return _enabled;
    }

    private function set_enabled(value:Bool):Bool
    {
        _enabled = value;

        _movieAssets.touchable = value;

        if (!_enabled)
        {
            up();

            if (_movieAssets.totalFrames > 3)
            {
                _movieAssets.gotoAndStop(3);
            }
        } else
        {
            up();
        }

        return value;
    }

    private function get_scaleOnTouch():Float
    {
        return _scaleOnTouch;
    }

    private function set_scaleOnTouch(value:Float):Float
    {
        return _scaleOnTouch = value;
    }
}