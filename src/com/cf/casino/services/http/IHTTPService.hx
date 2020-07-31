package com.cf.casino.services.http;

import com.cf.devkit.services.IService;

interface IHTTPService extends IService
{
    var url(get, never):String;
    var responseData(get, never):Dynamic;

    function sendRequest(url:String, data:Dynamic):IHTTPService;
}
