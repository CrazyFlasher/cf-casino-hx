package com.cf.slot.context;

import com.cf.slot.models.win.ISlotWinsModelImmutable;
import com.cf.slot.models.reels.IReelsModelImmutable;
import com.cf.slot.models.win.SlotWinsModel;
import com.cf.casino.models.win.IWinsModel;
import com.cf.slot.models.win.singleWin.SlotSingleWinModel;
import com.cf.casino.models.win.singleWin.ISingleWinModel;
import com.cf.slot.models.win.SlotWinsVo;
import com.cf.casino.models.win.WinsVo;
import com.cf.casino.models.win.singleWin.SingleWinVo;
import com.cf.slot.models.win.singleWin.SlotSingleWinVo;
import com.cf.casino.config.ICasinoConfig;
import com.cf.slot.config.SlotConfig;
import com.cf.casino.context.CasinoContextMessagesToCommandsMappings;
import com.cf.slot.models.reels.IReelsModel;
import com.cf.slot.models.win.ISlotWinsModel;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.context.ICasinoContext;
import com.cf.casino.context.AbstractCasinoContext;

class SlotContext extends AbstractCasinoContext implements ICasinoContext
{
    private var slotConfig:ISlotConfig;

    private var slotWinsModel:ISlotWinsModel;
    private var reelsModel:IReelsModel;

    override private function createConfig():Void
    {
        super.createConfig();

        slotConfig = cast casinoConfig;

        modelFactory.mapToValue(ISlotConfig, slotConfig);
        mediatorFactory.mapToValue(ISlotConfig, slotConfig);
        viewFactory.mapToValue(ISlotConfig, slotConfig);
    }

    override private function createModels():Void
    {
        super.createModels();

        reelsModel = modelFactory.getInstance(IReelsModel);
        addModel(reelsModel);

        slotWinsModel = cast winsModel;
    }

    override private function mapTypes():Void
    {
        super.mapTypes();

        factory.mapToType(CasinoContextMessagesToCommandsMappings, SlotContextMessagesToCommandsMappings);

        factory.mapToType(
            com.cf.casino.commands.HandleInitCommand,
            com.cf.slot.commands.HandleInitCommand
        );

        factory.mapToType(
            com.cf.casino.commands.UpdateModelsCommand,
            com.cf.slot.commands.UpdateModelsCommand
        );

        modelFactory.mapToType(ICasinoConfig, SlotConfig);

        modelFactory.mapToType(SingleWinVo, SlotSingleWinVo);
        modelFactory.mapToType(WinsVo, SlotWinsVo);
        modelFactory.mapToType(ISingleWinModel, SlotSingleWinModel);
        modelFactory.mapToType(IWinsModel, SlotWinsModel);
    }

    override private function mapValues():Void
    {
        super.mapValues();

        mediatorFactory.mapToValue(IReelsModelImmutable, reelsModel);
        viewFactory.mapToValue(IReelsModelImmutable, reelsModel);
        factory.mapToValue(IReelsModel, reelsModel);

        mediatorFactory.mapToValue(ISlotWinsModelImmutable, slotWinsModel);
        viewFactory.mapToValue(ISlotWinsModelImmutable, slotWinsModel);
        factory.mapToValue(ISlotWinsModel, slotWinsModel);
    }
}
