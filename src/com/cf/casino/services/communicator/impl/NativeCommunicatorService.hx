package com.cf.casino.services.communicator.impl;

import com.cf.casino.services.http.HTTPServiceMessageType;
import com.cf.casino.services.http.IHTTPService;
import com.domwires.core.factory.IAppFactory;
import haxe.Json;

class NativeCommunicatorService extends AbstractCommunicatorService implements ICommunicatorService
{
    @Inject("roundStateModel")
    private var roundStateModel:IStateModelImmutable;

    @Inject("modelFactory")
    private var modelFactory:IAppFactory;

    //TODO: inject
    private final game:String = "shibainu";
    private final gameSession:String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJnYW1lIjoic2hpYmFpbnUiLCJpc3MiOiJnYW5hcGF0aSIsImlzc3VlZEF0IjoibnVsbCIsImlhdCI6MTU2OTU2Njk3Mywib3BlcmF0b3IiOiJnYW5hbG9naWNzIiwicGxheWVyIjoibnVsbCIsImVuZ2luZUlkIjoic2hpYmFpbnUiLCJleHBpcmF0aW9uQ29uZmlndXJhdGlvblByb3BlcnR5Ijoic2VydmVyLmp3dC5leHBpcmF0aW9uLm1pbnMifQ.n4prtAWmPm6M66GFs5uqi0MwMvLS5OIx5n2-EqQv6ic";
    private final action:String = "spin";

    private var httpService:IHTTPService;

    override public function init():ICommunicatorService
    {
        httpService = modelFactory.getInstance(IHTTPService);
        httpService.addMessageListener(HTTPServiceMessageType.Response, response);

        handleInit(
            {
                reelStripsBG: [
                    [7,8,4,5,0,3,9,8,6,7,9,5,3,9,2,8,4,6,1,7,8,9,5,2,7,4,9,7,8,7,9,8,7,8,2,7,0,8,9,5,7,8,9,5,3],
                    [5,0,8,4,7,8,3,9,8,4,5,2,8,6,9,8,4,6,9,5,6,9,3,6,7,3,0,6,7,1,6,9,2,6,4,3,6,4],
                    [4,2,6,3,6,5,0,8,6,8,5,6,4,9,6,2,8,7,5,9,7,6,1,2,6,9,7,3,6],
                    [3,7,9,5,7,1,8,5,6,7,8,9,5,7,6,8,2,9,5,4,9,7,8,5,6,8,5,9,6,4,5,6,9,8,7,9,6,5,7,0,6,4,9,8,7,6,8,3,5,9,6,8],
                    [7,5,1,7,5,0,6,9,7,5,6,4,9,3,6,5,4,7,9,6,5,7,9,2,5,3,8,4,8,6,5,8,9,6,7,5,8,9,6,7,2,8,4,9,6,5,8,7,9,8,6,4,2,8,3,7,2,3,8,9]
                ],
                reelStripsFG: [
                    [7,8,4,5,0,3,9,8,6,7,9,5,3,9,2,8,4,6,1,7,8,9,5,2,7,4,9,7,8,7,9,8,7,8,2,7,0,8,9,5,7,8,9,5,3],
                    [5,0,8,4,7,8,3,9,8,4,5,2,8,6,0,9,8,4,6,9,5,6,9,3,6,7,3,0,6,7,1,6,9,2,6,4,3,6,4],
                    [4,2,6,3,6,5,0,8,6,8,5,6,4,9,6,2,8,7,0,5,9,7,6,1,2,6,9,7,3,6],
                    [3,7,9,5,7,1,8,5,6,7,8,9,5,0,7,6,8,2,9,5,4,9,7,8,5,6,8,5,9,6,4,5,6,9,8,7,9,6,5,7,0,6,4,9,8,7,6,8,3,5,9,6,8],
                    [7,5,1,7,5,0,6,9,7,5,6,4,9,3,6,5,4,7,9,6,5,7,9,2,5,3,8,4,8,6,0,5,8,9,6,7,5,8,9,6,7,2,8,4,9,6,5,8,7,9,8,6,4,2,8,3,7,2,3,8,9]
                ]
            }
        );

        return this;
    }

    override private function localize():Void
    {
        textsModel.set("BIG_WIN", "BIG_WIN");
        textsModel.set("FREE_GAMES_AWARD", "FREE_GAMES_AWARD");
        textsModel.set("TAP_TO_CONTINUE", "TAP_TO_CONTINUE");
        textsModel.set("AWARD", "AWARD");
    }

    private function response(m:IMessage):Void
    {
        handleResult(httpService.responseData.payload);
    }

    override public function perform():ICommunicatorService
    {
        handleRoundStart([roundStateModel.state == RoundState.Play ? "play" : "freeplay"]);

        var localState:Dynamic = {
            "initialBet": {
                "amount": 15,
                "value": 0.1
            },
            "roundTotalWin": 0.5,
            "freeGamesLeft": 0,
            "freeGamesTotal": 0
        };

        var request:Dynamic = {
            game: game,
            gameSession: gameSession,
            action: "spin",
            bet: {
                value: 0.1,
                amount: 15,
                total: 1.5
            },
            localState: Json.stringify(localState)
        };

        httpService.sendRequest("https://dev01.ganalogics.net:8080/demoplay", request);

        return this;
    }

    override public function preloadingComplete():ICommunicatorService
    {
        super.preloadingComplete();

        handleStart();

        return this;
    }

    override public function resultsShown():ICommunicatorService
    {
        //temporary do nothing

        return this;
    }
}
