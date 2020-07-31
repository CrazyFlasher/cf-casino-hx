package com.cf.casino.views;

import com.cf.devkit.bundle.IMovieClip;
import haxe.io.Error;

#if !useStarling
    import openfl.display.DisplayObject;
#else
    import starling.display.DisplayObject;
#end

class MovieClipView extends View implements IMovieClipView
{
    public var movieAssets(get, set):IMovieClip;

    private var _movieAssets:IMovieClip;

    private function get_movieAssets():IMovieClip
    {
        return _movieAssets;
    }

    private function set_movieAssets(value:IMovieClip):IMovieClip
    {
        _movieAssets = value;

        super.set_displayObjectAssets(_movieAssets);

        return value;
    }

    override public function show(value:Bool):Void
    {
        if (_movieAssets != null)
        {
            _movieAssets.visible = value;
        } else
        {
            super.show(value);
        }
    }

    override public function isShown():Bool
    {
        return _movieAssets != null ? _movieAssets.visible : super.isShown();
    }

    override private function set_assets(value:DisplayObject):DisplayObject
    {
        throw Error.Custom("Use movieAssets setter of instantiate base class");
    }
}
