package com.cf.casino.views;

import com.cf.devkit.bundle.IDisplayObject;
import com.domwires.core.mvc.message.IMessageDispatcher;

#if !useStarling
import openfl.display.DisplayObject;
#else
import starling.display.DisplayObject;
#end

interface IView extends IMessageDispatcher
{
    var assets(get, set):DisplayObject;
    var displayObjectAssets(get, set):IDisplayObject;

    function show(value:Bool):Void;
}
