package com.cf.casino.commands;

#if !useStarling
import openfl.events.Event;
#else
import openfl.Lib;
import starling.events.ResizeEvent;
import com.cf.devkit.display.Stage;
import com.cf.devkit.commands.AbstractAppCommand;
import starling.events.Event;
#end

class ResizeCommand extends AbstractAppCommand
{
    override public function execute():Void
    {
        super.execute();

        Stage.get().dispatchEvent(
            #if !useStarling
                new Event(Event.RESIZE)
            #else
                new ResizeEvent(ResizeEvent.RESIZE, Lib.application.window.stage.stageWidth, Lib.application.window.stage.stageHeight)
            #end
        );
    }
}
