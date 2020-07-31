package com.cf.casino.views.ui.impl;

import starling.events.TouchPhase;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.display.Canvas;
import starling.display.Sprite;
import com.cf.devkit.services.resources.IResourceServiceImmutable;

class NativeUIViewStarling extends AbstractUIView implements IUIView
{
    #if useStarling

    @Inject
    private var res:IResourceServiceImmutable;

    private var container:Sprite;
    private var button:Canvas;

    override private function init():Void
    {
        super.init();

        container = new Sprite();
        set_assets(container);

        button = new Canvas();
        button.beginFill(0xff0000);
        button.drawCircle(0, 0, 100);
        button.endFill();

        container.addChild(button);

        button.addEventListener(TouchEvent.TOUCH, (e:TouchEvent) -> {
            var t:Touch = e.getTouch(button, TouchPhase.BEGAN);
            if (t != null)
            {
                dispatchMessage(UIViewMessageType.PerformClicked);
            }
        });

        button.x = 700;
        button.y = 600;
    }

    override private function get_musicVolume():Float
    {
        return 1;
    }

    override private function get_sfxVolume():Float
    {
        return 1;
    }

    override private function get_fastPlay():Bool
    {
        return false;
    }

    #end
}
