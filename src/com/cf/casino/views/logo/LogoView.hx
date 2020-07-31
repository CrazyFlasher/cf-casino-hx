package com.cf.casino.views.logo;

import starling.utils.Align;
import com.cf.devkit.display.Stage;
import com.cf.devkit.bundle.IDisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class LogoView extends View
{
    @Inject("safeArea")
    private var safeArea:Rectangle;

    public var scale:Bool = true;

    private var initialY:Float;
    private var initialHeight:Float;

    private var helper:Point = new Point();

    private var manualyHidden:Bool;

    override private function set_displayObjectAssets(value:IDisplayObject):IDisplayObject
    {
        super.set_displayObjectAssets(value);

        setup();

        return value;
    }

    override public function show(value:Bool):Void
    {
        super.show(value);

        manualyHidden = !value;

        if (!manualyHidden)
        {
            onStageResize();
        }
    }

    private function setup():Void
    {
        initialY = _assets.y;
        initialHeight = _assets.height;

        #if useStarling
        _displayObjectAssets.assets.alignPivot(Align.CENTER, Align.TOP);
        #end

        Stage.addResizeListener(onStageResize);

        onStageResize();
    }

    private function onStageResize(event:Dynamic = null):Void
    {
        if (manualyHidden) return;

        helper.y = Stage.get().stageHeight * safeArea.top;

        var topY:Float = _assets.parent.globalToLocal(helper).y;
        var bottomY:Float = initialY + initialHeight;
        var logoVerticalSpace:Float = bottomY - topY;
        var newLogoHeight:Float = scale ? logoVerticalSpace : initialHeight;

        if (newLogoHeight > initialHeight * 2)
        {
            newLogoHeight = initialHeight * 2;
        }

        var logoY:Float = topY + (logoVerticalSpace - newLogoHeight) / 2;

        _assets.y = logoY;
        _assets.height = newLogoHeight;
        _assets.scaleX = _assets.scaleY;

        _assets.visible = _assets.scaleY >= 0.6;
    }
}
