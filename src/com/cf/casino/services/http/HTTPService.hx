package com.cf.casino.services.http;

import com.cf.devkit.services.AbstractService;
import haxe.Json;
import openfl.events.Event;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;

class HTTPService extends AbstractService implements IHTTPService
{
    private var loader:URLLoader = new URLLoader();
    private var request:URLRequest = new URLRequest();

    public var url(get, never):String;
    public var responseData(get, never):Dynamic;

    private var _url:String;
    private var _responseData:Dynamic;

    @PostConstruct
    private function init():Void
    {
        request.method = URLRequestMethod.POST;
        request.contentType = "application/json";

        loader.addEventListener(Event.COMPLETE, loaded);
    }

    private function loaded(e:Event):Void
    {
        _responseData = Json.parse(loader.data);

        trace("Response: " + _responseData);

        dispatchMessage(HTTPServiceMessageType.Response);
    }

    public function sendRequest(url:String, data:Dynamic):IHTTPService
    {
        trace("Request: " + data);

        _url = url;

        request.data = Json.stringify(data);
        request.url = url;

        loader.load(request);

        return this;
    }

    private function get_url():String
    {
        return _url;
    }

    private function get_responseData():Dynamic
    {
        return _responseData;
    }
}
