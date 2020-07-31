package com.cf.slot.commands;

import com.cf.casino.models.state.enums.AppState;
import com.cf.devkit.bundle.DisplayObjectMessageType;
import com.cf.devkit.display.Stage;
import com.cf.devkit.bundle.IMovieClip;
import com.cf.devkit.services.resources.IResourceService;
import com.cf.casino.models.state.IStateModel;
import com.cf.casino.config.ICasinoConfig;
import com.cf.devkit.commands.AbstractAppCommand;
import com.domwires.core.mvc.message.IMessage;
import openfl.display.BitmapData;
import openfl.filters.BitmapFilterQuality;
import openfl.filters.BlurFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class PrerenderSymbolsCommand extends AbstractAppCommand
{
    @Inject
    private var config:ICasinoConfig;

    @Inject("appStateModel")
    private var appStateModel:IStateModel;

    @Inject
    private var res:IResourceService;

    private var swfSymbols:IMovieClip;

    override public function execute():Void
    {
        super.execute();

        if (!res.hasMovieClipLibrary())
        {
            retain();
        } else
        {
            swfSymbols = res.getMovieClip("symbol");

            if (swfSymbols != null)
            {
                swfSymbols.x = swfSymbols.y = -5000;
                Stage.get().addChild(swfSymbols.canvas);

                swfSymbols.addMessageListener(DisplayObjectMessageType.EnterFrame, prerenderNext);

                prerender();
            } else
            {
                retain();
            }
        }
    }

    private function prerender():Void
    {
        trace("Prerendering: " + "symbols/" + swfSymbols.currentFrame + " " + swfSymbols.width + " " + swfSymbols.height);

        var m:Matrix = new Matrix();
        m.scale(0.25, 0.25);
        m.ty += swfSymbols.height * 0.10;
//        m.tx += swfSymbols.width * 0.02;

        #if !useStarling
        var bd:BitmapData = new BitmapData(Std.int(swfSymbols.width * 0.25), Std.int(swfSymbols.height * 0.4), true, 0);
        swfSymbols.drawToBitmapData(bd, m);
        #else
        var bd = swfSymbols.drawToBitmapData(null, m);
        #end

        bd.applyFilter(bd, new Rectangle(0, 0, bd.width, bd.height), new Point(), new BlurFilter(2, 20, BitmapFilterQuality.HIGH));

        var id:String = "symbols/" + (swfSymbols.currentFrame);
        res.setBitmapData(id, bd);
    }

    private function prerenderNext(m:IMessage):Void
    {
        swfSymbols.nextFrame();

        prerender();

        if (swfSymbols.currentFrame == swfSymbols.totalFrames - 1)
        {
            swfSymbols.removeMessageListener(DisplayObjectMessageType.EnterFrame, prerenderNext);

            swfSymbols.canvas.parent.removeChild(swfSymbols.canvas);

            trace("Prerender complete!");
            retain();
        }
    }

    private function retain():Void
    {
        appStateModel.setState(AppState.PrerenderComplete);
    }
}
