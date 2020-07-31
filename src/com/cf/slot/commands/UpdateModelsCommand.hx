package com.cf.slot.commands;

import com.cf.slot.models.win.singleWin.winLine.IWinLineModelImmutable;
import com.cf.slot.models.reels.ReelsVo;
import com.cf.slot.models.win.ISlotWinsModel;
import com.cf.slot.models.reels.IReelsModel;

class UpdateModelsCommand extends com.cf.casino.commands.UpdateModelsCommand
{
    @Inject
    private var reelsModel:IReelsModel;

    @Inject
    private var slotWinsModel:ISlotWinsModel;

    private var reelsVo:ReelsVo;

    @PostConstruct
    override private function init():Void
    {
        super.init();

        if (reelsVo == null)
        {
            reelsVo = modelFactory.getInstance(ReelsVo);
        }
    }

    override private function updateModels():Void
    {
        super.updateModels();

        updateReelsModel();
    }

    private function updateReelsModel():Void
    {
        reelsVo.update(result);
        reelsModel.update(reelsVo);

        updateWinSymbols();
    }

    private function updateWinSymbols():Void
    {
        for (singleWinModel in slotWinsModel.slotSingleWinModelList)
        {
            if (singleWinModel.winLine != null)
            {
                var winLineModel:IWinLineModelImmutable = singleWinModel.winLine;
                for (reelIndex in 0...winLineModel.positionIdList.length)
                {
                    if (reelIndex < singleWinModel.count)
                    {
                        reelsModel.getReelByIndex(reelIndex).getSymbolByIndex(winLineModel.positionIdList[reelIndex])
                            .addWin(winLineModel.id);
                    }
                }
            }
        }
    }
}
