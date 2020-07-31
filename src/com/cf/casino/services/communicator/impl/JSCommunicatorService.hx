package com.cf.casino.services.communicator.impl;

class JSCommunicatorService extends AbstractCommunicatorService implements ICommunicatorService
{
    private var onLoadingProgressUpdate:Float -> Void;
    private var onLoadingCompleted:Void -> Void;

    override public function init():ICommunicatorService
    {
        untyped game = this;
        untyped __js__("
            gAPI.wrapper.initialize({
                casinoUI: {
                    settings: [
                        { label: 'sound', type: 'slider', value: 100 },
                        { label: 'music', type: 'slider', value: 100 },
                        { label: 'fastplay', type: 'toggle', value: false }
                    ]
                },
                handler: {
                    initialize: initData => new Promise(resolve => {
                        game.setOnLoadingCompleted(resolve);
                        game.setOnLoadingProgress(gAPI.casinoUI.loader());
                        game.handleInit(initData)
                    }),

                    resume: prevResponse => new Promise(resolve => {
                        gAPI.casinoUI.visible = true

                        game.handleStart();

                        if(!prevResponse)
                        {
                            return resolve();
                        }

                        game.onAnimationsCompleted = function(){
                            gAPI.casinoUI.totalWin = prevResponse.roundTotalWin

                            resolve()
                        }

                        let freeGamesLeft = prevResponse.freeGamesLeft;

                        if (!prevResponse.roundEnd)
                        {
                            if (prevResponse.wins)
                            {
                                prevResponse.wins.forEach(w => {if (w.freeGamesAwarded) freeGamesLeft -= w.freeGamesAwarded})
                            }

                            game.handleUnFinishedGame(prevResponse)
                        }

                        Promise.resolve(!prevResponse.roundEnd && gAPI.casinoUI.showAlert({ errorCode: 604 }))
                        .then(() => {
                            prevResponse.autoplay = gAPI.casinoUI.autoplay;
                            game.handlePrevResult(prevResponse);
                        })
                    }),
                    handle: response => new Promise(resolve => {
                        if(!response.roundEnd) gAPI.casinoUI.stopAutoplay()

                        game.onAnimationsCompleted = function(){
                            gAPI.casinoUI.totalWin = response.roundTotalWin
                            resolve()
                        }
                        response.autoplay = gAPI.casinoUI.autoplay
                        game.handleResult(response)
                    }),
                    select: actions => new Promise(resolve => {
                        var resolveObj = {action: actions[0]};
                        if (game.getPayload())
                        {
                            resolveObj.payload = game.getPayload();
                        }
                        game.handleRoundStart(actions);
                        resolve(resolveObj);
                    }),
                    reset: error => {
                        console.log(error)
                        game.onAnimationsCompleted = function(){}
                        game.handleError(error)
                    }
                }
            })
        ");

        return this;
    }

    override private function localize():Void
    {
        var map:Dynamic = untyped gAPI.casinoUI.translations;

        for (key in Reflect.fields(map.labels))
        {
            trace(key + " -> " + Reflect.field(map.labels, key));
            textsModel.set(key, Reflect.field(map.labels, key));
        }
    }

    @:keep
    private function setOnLoadingCompleted(value:Void -> Void):Void
    {
        onLoadingCompleted = value;
    }

    @:keep
    private function setOnLoadingProgress(value:Float -> Void):Void
    {
        onLoadingProgressUpdate = value;
    }

    override public function updatePreloadingProgress(progress:Float):ICommunicatorService
    {
        super.updatePreloadingProgress(progress);

        onLoadingProgressUpdate(progress);

        return this;
    }

    override public function preloadingComplete():ICommunicatorService
    {
        super.preloadingComplete();

        onLoadingCompleted();

        return this;
    }

    override public function resultsShown():ICommunicatorService
    {
        untyped game.onAnimationsCompleted();

        return this;
    }

    override public function perform():ICommunicatorService
    {
        //do nothing

        return this;
    }
}
