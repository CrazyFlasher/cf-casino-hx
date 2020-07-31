package com.cf.casino.commands;

import com.cf.casino.models.state.enums.RoundState.RoundStateFromString;
import com.cf.casino.models.win.WinsVo;
import com.cf.casino.models.win.IWinsModel;
import com.cf.casino.models.app.IAppModel;
import com.cf.devkit.models.pause.IPauseModel;
import com.cf.casino.models.state.IStateModel;
import com.cf.casino.services.communicator.ICommunicatorService;
import com.cf.casino.models.payload.IPayloadModel;
import com.cf.casino.config.ICasinoConfig;
import com.cf.devkit.commands.AbstractAppCommand;
import com.domwires.core.factory.IAppFactory;

class UpdateModelsCommand extends AbstractAppCommand
{
    @Inject
    private var config:ICasinoConfig;

    @Inject("modelFactory")
    private var modelFactory:IAppFactory;

    @Inject
    private var payloadModel:IPayloadModel;

    @Inject
    private var comService:ICommunicatorService;

    @Inject("appStateModel")
    private var appStateModel:IStateModel;

    @Inject("roundStateModel")
    private var roundStateModel:IStateModel;

    @Inject
    private var pauseModel:IPauseModel;

    @Inject
    private var appModel:IAppModel;

    @Inject
    private var winsModel:IWinsModel;

    private var result:Dynamic;

    private var winsVo:WinsVo;

    @PostConstruct
    private function init():Void
    {
        if (winsVo == null)
        {
            winsVo = modelFactory.getInstance(WinsVo);
        }
    }

    override public function execute():Void
    {
        super.execute();

        result = comService.result;

        updateModels();

        updateStateModels();
    }

    private function updateModels():Void
    {
        updateWinsModel();
        updateAppModel();
    }

    private function updateWinsModel():Void
    {
        winsVo.update(result);
        winsModel.update(winsVo);
    }

    private function updateAppModel():Void
    {
        appModel.setBetValue(result.initialBet.value);
        appModel.setBetAmount(result.initialBet.amount);
        appModel.setTotalBetValue(result.totalBet);
        appModel.setAutoPlay(result.autoplay);
        appModel.setTotalWin(result.totalWin);
        appModel.setRoundTotalWin(result.roundTotalWin);
        appModel.setIsRoundEnd(result.roundEnd);
        appModel.setReplacementIdList(result.replacement);

        var freeGamesCount:Int = result.freeGamesLeft == null ? 0 : result.freeGamesLeft;
        appModel.setFreeGamesCount(freeGamesCount);
    }

    private function updateStateModels():Void
    {
        var roundState:EnumValue = getRoundStateFromString(result.action);
        var nextRoundState:EnumValue = getRoundStateFromString(result.nextAction[0]);

        roundStateModel.setNextState(nextRoundState);
        roundStateModel.setState(roundState);
    }

    private function getRoundStateFromString(name:String):EnumValue
    {
        return RoundStateFromString.get(name);
    }
}
