package com.cf.casino.services.communicator;

import com.cf.devkit.services.IService;

interface ICommunicatorService extends IService
{
    function init():ICommunicatorService;
    function perform():ICommunicatorService;
    function resultsShown():ICommunicatorService;
    function updatePreloadingProgress(progress:Float):ICommunicatorService;
    function preloadingComplete():ICommunicatorService;
    function getPayload():Dynamic;

    var initData(get, never):Dynamic;
    var result(get, never):Dynamic;
    var actionIdList(get, never):Array<String>;
    var error(get, never):String;
}
