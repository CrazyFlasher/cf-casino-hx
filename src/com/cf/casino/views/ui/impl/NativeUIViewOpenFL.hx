package com.cf.casino.views.ui.impl;

import com.cf.devkit.services.resources.IResourceServiceImmutable;
import feathers.controls.Button;
import feathers.controls.ButtonState;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.AutoSizeMode;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;

class NativeUIViewOpenFL extends AbstractUIView implements IUIView
{
    #if !useStarling
    @Inject
    private var res:IResourceServiceImmutable;

    private var container:LayoutGroup;

    private var buttonGroup:LayoutGroup;
        private var spinBtn:Button;
        private var arrow:LayoutGroup;

    override private function init():Void
    {
        super.init();

        container = new LayoutGroup();
        container.autoSizeMode = cast AutoSizeMode.STAGE;
        container.layout = new AnchorLayout();

        set_assets(container);

        buttonGroup = createButtonGroup();
        container.addChild(buttonGroup);

        buttonGroup.scaleX = buttonGroup.scaleY = 0.2;
    }

    private function createButtonGroup():LayoutGroup
    {
        var group:LayoutGroup = new LayoutGroup();
        group.layout = new AnchorLayout();

        var layoutData:AnchorLayoutData = new AnchorLayoutData();
        layoutData.bottom = 10.0;
        layoutData.right = 10.0;

        group.layoutData = layoutData;

        spinBtn = createSpinButton();
        group.addChild(spinBtn);

        arrow = createArrow();
        group.addChild(arrow);

        group.alpha = 0.90;

        return group;
    }

    private function createArrow():LayoutGroup
    {
        var group:LayoutGroup = new LayoutGroup();
        group.mouseEnabled = false;

        group.backgroundSkin = new Bitmap(res.getBitmapData("ui/spin.png"), null, true);

        var layoutData:AnchorLayoutData = new AnchorLayoutData();
        layoutData.verticalCenter = layoutData.horizontalCenter = 0.0;
        group.layoutData = layoutData;

        return group;
    }

    private function createSpinButton():Button
    {
        var button:Button = new Button();

        var layoutData:AnchorLayoutData = new AnchorLayoutData();
        layoutData.verticalCenter = layoutData.horizontalCenter = 0.0;
        button.layoutData = layoutData;

        button.setSkinForState(ButtonState.UP, new Bitmap(res.getBitmapData("ui/spin-bg.png"), null, true));
        button.setSkinForState(ButtonState.HOVER, new Bitmap(res.getBitmapData("ui/spin-bg.hover.png"), null, true));
        button.setSkinForState(ButtonState.DOWN, new Bitmap(res.getBitmapData("ui/spin-bg.down.png"), null, true));

        button.addEventListener(MouseEvent.CLICK, mouseClicked);

        return button;
    }

    private function mouseClicked(e:MouseEvent):Void
    {
        dispatchMessage(UIViewMessageType.PerformClicked);
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

    override public function showSpinButton(value:Bool):Void
    {
        buttonGroup.visible = value;
    }
    #end
}