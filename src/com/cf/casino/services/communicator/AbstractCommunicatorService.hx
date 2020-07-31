package com.cf.casino.services.communicator;

import com.cf.casino.models.payload.IPayloadModelImmutable;
import com.cf.casino.models.texts.ITextsModel;
import com.cf.devkit.services.AbstractService;
import haxe.io.Error;

class AbstractCommunicatorService extends AbstractService implements ICommunicatorService
{
    @Inject
    private var textsModel:ITextsModel;

    @Inject
    private var payloadModel:IPayloadModelImmutable;

    public var initData(get, never):Dynamic;
    public var result(get, never):Dynamic;
    public var actionIdList(get, never):Array<String>;
    public var error(get, never):String;

    private var _initData:Dynamic;
    private var _result:Dynamic;
    private var _actionIdList:Array<String>;
    private var _error:String;

    public function init():ICommunicatorService
    {
        throw Error.Custom("Override!");
    }

    @:keep
    private function handleInit(value:Dynamic):Void
    {
        trace("handleInit: " + value);

        _initData = value;

        localize();

        dispatchMessage(CommunicatorMessageType.HandleInit);
    }

    private function localize():Void
    {
        throw Error.Custom("Override!");
    }

    @:keep
    private function handleStart():Void
    {
        trace("handleStart");

        dispatchMessage(CommunicatorMessageType.HandleStart);
    }

    @:keep
    private function handleUnFinishedGame(value:Dynamic):Void
    {
        trace("handleUnFinishedGame: " + value);

        _result = value;

        dispatchMessage(CommunicatorMessageType.HandleUnfinishedGame);
    }

    @:keep
    private function handlePrevResult(value:Dynamic):Void
    {
        trace("handlePrevResult: " + value);

        _result = value;

        dispatchMessage(CommunicatorMessageType.HandlePrevResult);
    }

    @:keep
    private function handleResult(value:Dynamic):Void
    {
        trace("handleResult: " + value);

        _result = value;

        dispatchMessage(CommunicatorMessageType.HandleResult);
    }

    @:keep
    private function handleRoundStart(actionIdList:Array<String>):Void
    {
        trace("handleRoundStart: " + actionIdList);

        _actionIdList = actionIdList;

        dispatchMessage(CommunicatorMessageType.HandleRoundStart);
    }

    @:keep
    private function handleError(value:String):Void
    {
        trace("handleError: " + value);

        _error = value;

        dispatchMessage(CommunicatorMessageType.HandleError);
    }

    @:keep
    public function getPayload():Dynamic
    {
        return payloadModel.value;
    }

    public function perform():ICommunicatorService
    {
        throw Error.Custom("Override!");
    }

    public function resultsShown():ICommunicatorService
    {
        throw Error.Custom("Override!");
    }

    public function updatePreloadingProgress(progress:Float):ICommunicatorService
    {
        return this;
    }

    public function preloadingComplete():ICommunicatorService
    {
        trace("preloadingComplete");

        updatePreloadingProgress(1.0);

        return this;
    }

    private function get_initData():Dynamic
    {
        return _initData;
    }

    private function get_result():Dynamic
    {
        return _result;
    }

    private function get_actionIdList():Array<String>
    {
        return _actionIdList;
    }

    private function get_error():String
    {
        return _error;
    }
}
