package com.cf.slot.views.reels.symbol;

import com.cf.devkit.trace.Trace;
import com.cf.devkit.tween.ITween;
import com.cf.devkit.bundle.IMovieClip;
import com.cf.slot.models.reels.singleReel.symbol.ISymbolModelImmutable;
import com.cf.casino.models.app.IAppModelImmutable;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.views.MovieClipView;

class SymbolView extends MovieClipView
{
    @Inject
    private var config:ISlotConfig;

    @Inject
    private var appModel:IAppModelImmutable;

    public var blur(get, never):Bool;
    public var id(get, set):Int;
    public var index(get, set):Int;
    public var model(get, set):ISymbolModelImmutable;
    public var originY(get, never):Float;
    public var width(get, never):Float;
    public var height(get, never):Float;

    private var _blur:Bool = false;
    private var _id:Int = -1;
    private var _index:Int = -1;
    private var _model:ISymbolModelImmutable;
    private var _originY:Float;

    private var normal:IMovieClip;
    private var blured:IMovieClip;

    private var blurTween:ITween;

    public var firstInCombinationSequence(get, never):SymbolView;
    private var _firstInCombinationSequence:SymbolView;

    override private function init():Void
    {
        super.init();

        blurTween = viewFactory.getInstance(ITween);
    }

    private function get_id():Int
    {
        return _id;
    }

    private function set_id(value:Int):Int
    {
        if (_firstInCombinationSequence != null)
        {
            setIsCombined(null, 0);
        }

        var indexInMysteryIdList:Int = config.mysterySymbolIdList.indexOf(value);
        if (appModel.replacementIdList != null && indexInMysteryIdList != -1)
        {
            _id = appModel.replacementIdList[indexInMysteryIdList];
        } else
        {
            _id = value;
        }

        if (_id >= normal.totalFrames)
        {
            trace("Replacing '" + _id + "' to random value, because 'appModel.replacementIdList' is null in response...", Trace.WARNING);
            _id = Math.floor(Math.random() * normal.totalFrames);
        }

        updateSymbol();

        return _id;
    }

    private function updateSymbol():Void
    {
        normal.gotoAndStop(_id);
        blured.gotoAndStop(normal.currentFrame);
    }

    public function setBlur(value:Bool, duration:Float, ease:String = "linear"):Void
    {
        _blur = value;

        if (blurTween != null)
        {
            blurTween.stop();
        }

        animateBlurTransition(value, duration, ease);
    }

    private function animateBlurTransition(blur:Bool, duration:Float, ease:String):Void
    {
        if (duration > 0)
        {
            blurTween.setOnUpdate(() -> blured.alpha = 1 - normal.alpha);
            blurTween.tween(normal, duration, {alpha: !blur ? 1 : 1 - config.maxBlurOpacity}, ease);
        } else
        {
            normal.alpha = !blur ? 1 : 1 - config.maxBlurOpacity;
        }
    }

    private function get_blur():Bool
    {
        return _blur;
    }

    private function get_index():Int
    {
        return _index;
    }

    private function set_index(value:Int):Int
    {
        return _index = value;
    }

    override public function set_movieAssets(value:IMovieClip):IMovieClip
    {
        super.movieAssets = value;

        normal = value.getMovieClip("normal");
        blured = value.getMovieClip("blured");
        blured.alpha = 0.0;

        _originY = value.y;

        return value;
    }

    public function setIsCombined(firstInSequence:SymbolView, count:Int):Void
    {
        _firstInCombinationSequence = firstInSequence;
    }

    public function showHighLight(loop:Bool = true, highLightIterationIndex:Int = 0):Void
    {

    }

    public function hideHighLight(highLightIterationIndex:Int = 0):Void
    {

    }

    public function reset():Void
    {

    }

    private function get_model():ISymbolModelImmutable
    {
        return _model;
    }

    private function set_model(value:ISymbolModelImmutable):ISymbolModelImmutable
    {
        return _model = value;
    }

    private function get_originY():Float
    {
        return _originY;
    }

    private function get_width():Float
    {
        return _assets.width;
    }

    private function get_height():Float
    {
        return _assets.height;
    }

    private function get_firstInCombinationSequence():SymbolView
    {
        return _firstInCombinationSequence;
    }
}
