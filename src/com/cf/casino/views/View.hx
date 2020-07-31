package com.cf.casino.views;

import com.cf.devkit.bundle.IDisplayObject;
import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.message.MessageDispatcher;

#if !useStarling
import openfl.display.DisplayObject;
#else
import starling.display.DisplayObject;
#end

class View extends MessageDispatcher implements IView
{
    @Inject("viewFactory")
    private var viewFactory:IAppFactory;

    public var assets(get, set):DisplayObject;
    public var displayObjectAssets(get, set):IDisplayObject;

    private var _displayObjectAssets:IDisplayObject;
    private var _assets:DisplayObject;

    @PostConstruct
    private function init():Void
    {

    }

    public function show(value:Bool):Void
    {
        if (_displayObjectAssets != null)
        {
            _displayObjectAssets.visible = value;
        } else
        {
            _assets.visible = value;
        }
    }

    public function isShown():Bool
    {
        return _displayObjectAssets != null ? _displayObjectAssets.visible : _assets.visible;
    }

    private function get_assets():DisplayObject
    {
        return _assets;
    }

    private function set_assets(value:DisplayObject):DisplayObject
    {
        return _assets = value;
    }

    private function get_displayObjectAssets():IDisplayObject
    {
        return _displayObjectAssets;
    }

    private function set_displayObjectAssets(value:IDisplayObject):IDisplayObject
    {
        _assets = value.assets;

        return _displayObjectAssets = value;
    }
}
