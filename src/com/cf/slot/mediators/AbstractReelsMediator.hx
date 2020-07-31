package com.cf.slot.mediators;

import com.cf.devkit.bundle.IDisplayObject;
import com.cf.devkit.bundle.IMovieClip;
import com.cf.slot.models.win.ISlotWinsModelImmutable;
import com.cf.slot.models.reels.IReelsModelImmutable;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.mediators.AbstractAppMediator;
import com.ganapati.slot.config.ExtraAnticipationVo;
import com.ganapati.casino.models.win.singleWin.ISingleWinModelImmutable;
import com.ganapati.devkit.trace.Trace;
import com.ganapati.casino.models.app.IAppModelImmutable;
import com.ganapati.casino.models.state.enums.RoundState;
import com.ganapati.casino.models.state.StateModelMessageType;
import com.domwires.core.mvc.message.IMessage;
import com.domwires.core.utils.ArrayUtils;
import com.ganapati.casino.mediators.AbstractAppMediator;
import com.ganapati.casino.models.state.enums.AppState;
import com.ganapati.casino.models.state.IStateModelImmutable;
import com.ganapati.devkit.bundle.IDisplayObject;
import com.ganapati.devkit.bundle.IMovieClip;
import com.ganapati.slot.config.ISlotConfig;
import com.ganapati.slot.models.reels.IReelsModelImmutable;
import com.ganapati.slot.models.reels.singleReel.ISingleReelModelImmutable;
import com.ganapati.slot.models.win.ISlotWinsModelImmutable;
import com.ganapati.slot.models.win.singleWin.ISlotSingleWinModelImmutable;
import com.ganapati.slot.models.win.singleWin.winLine.IWinLineModelImmutable;
import com.ganapati.slot.views.reels.single.SingleReelView;
import com.ganapati.slot.mediators.WinsMediator.WinsMediatorMessageType;

class AbstractReelsMediator extends AbstractAppMediator
{
	@Inject
	private var config:ISlotConfig;

	@Inject
	private var model:IReelsModelImmutable;

	@Inject
	private var slotWinsModel:ISlotWinsModelImmutable;

	public var isBusy(get, never):Bool;
	private var _isBusy:Bool;

	private var reelViewList:Array<SingleReelView>;
	private var lastReelAnimationStarted:Bool;
	private var nextReel:SingleReelView;
	private var fastPlay:Bool;
	private var isFreeSpin:Bool;
	private var showWithAnticipation:Bool;
	private var extraAnticipationSymbolCountRevealed:Map<Int, Int>;
	private var _extraAnticipationStarted:Bool;

	private var gameAssets:IMovieClip;
	private var displayAssets:IMovieClip;
	private var displayMask:IDisplayObject;

	private var canSkip:Bool;
	private var skip:Bool;
	private var autoSkipAfterResponseReceived:Bool;

	override private function init():Void
	{
		super.init();

		gameAssets = getAssetsContainer();
		displayAssets = getDisplayAssetsContainer();
		displayMask = getDisplayMaskAssets();

		createViews();

		show(false);
	}

	override private function handleScreenClick(m:IMessage):Void
	{
		super.handleScreenClick(m);

		checkIfCanSkip();
	}

	private function checkIfCanSkip():Void
	{
		if (config.skipReelsAnticipationAllowed)
		{
			if (_isBusy && !skip)
			{
				if (canSkip)
				{
					skip = true;
					canSkip = false;
					skipReelsAnticipation();
				} else
				if (!autoSkipAfterResponseReceived)
				{
					autoSkipAfterResponseReceived = true;
				}
			}
		}
	}

	private function skipReelsAnticipation():Void
	{
		if (_extraAnticipationStarted)
		{
			_extraAnticipationStarted = false;

			for (reelView in reelViewList)
			{
				reelView.resetSpeedMultiplier();
			}
		}

		setTimeScale(2.0);
	}

	private function setTimeScale(value:Float):Void
	{
		for (reelView in reelViewList)
		{
			reelView.setTimeScale(value);
		}
	}

	private function getDisplayAssetsContainer():IMovieClip
	{
		throw haxe.io.Error.Custom("Override!");
	}

	private function getAssetsContainer():IMovieClip
	{
        throw haxe.io.Error.Custom("Override!");
	}

	private function getDisplayMaskAssets():IDisplayObject
	{
        throw haxe.io.Error.Custom("Override!");
	}

	override public function show(value:Bool):Void
	{
		displayAssets.visible = value;
	}

	private function createViews():Void
	{
		reelViewList = [];

		var reelIndex:Int;
		var reelView:SingleReelView;

		for (singleReelModel in model.singleReelModelListImmutable)
		{
			viewFactory.mapToValue(ISingleReelModelImmutable, singleReelModel);
			reelView = viewFactory.getInstance(SingleReelView);
			reelView.addMessageListener(SingleReelViewMessageType.AnticipationCompleted, singleReelAnimationCompleted);
			reelView.movieAssets = gameAssets;

			reelViewList.push(reelView);
		}

		var lastReelUI:SingleReelView = reelViewList[reelViewList.length - 1];
		lastReelUI.addMessageListener(SingleReelViewMessageType.AnticipationStarted, lastReelViewAnimationStarted);

		createMask();
	}

	private function createMask():Void
	{
		if (displayAssets != null && displayMask != null)
		{
			displayAssets.mask = displayMask.assets;
		}
	}

	private function updateReels():Void
	{
		for (i in 0...model.singleReelModelListImmutable.length)
		{
			reelViewList[i].updateSymbolAssets();
		}
	}

	private function showResult():Void
	{
		skip = false;
		canSkip = false;
		autoSkipAfterResponseReceived = false;

		_isBusy = showWithAnticipation;

		extraAnticipationSymbolCountRevealed = new Map<Int, Int>();
		_extraAnticipationStarted = false;

		lastReelAnimationStarted = !showWithAnticipation;

		this.fastPlay = appModel.fastPlay;
		this.isFreeSpin = roundStateModel.state == RoundState.FreePlay;

		highLightSymbols(false);

		for (i in 0...model.singleReelModelListImmutable.length)
		{
			reelViewList[i].showResult(showWithAnticipation, fastPlay, isFreeSpin);
		}

		if (!showWithAnticipation)
		{
			animationCompleted();
		}
	}

	private function get_isBusy():Bool
	{
		return _isBusy;
	}

	private function singleReelAnimationCompleted(m:IMessage):Void
	{
		var reelView:SingleReelView = cast m.target;
		var reelModel:ISingleReelModelImmutable = reelView.model;

		trace("singleReelAnimationCompleted: " + reelModel.index, Trace.INFO);

		nextReel = !ArrayUtils.isLast(reelViewList, reelView) ? reelViewList[reelView.model.index + 1] : null;

		singleReelAnticipationCompleted();

		if (config.extraAnticipation != null)
		{
			for (symbolId in config.extraAnticipation.symbolIdToCount.keys())
			{
				if (!extraAnticipationSymbolCountRevealed.exists(symbolId))
				{
					extraAnticipationSymbolCountRevealed.set(symbolId, 0);
				}

				extraAnticipationSymbolCountRevealed.set(symbolId, extraAnticipationSymbolCountRevealed.get(symbolId)
					+ reelModel.getSymbolCount(symbolId));
			}
		}

		if (nextReel == null)
		{
			animationCompleted();
		} else
		{
			if (config.extraAnticipation != null)
			{
				var anticipate:Bool = true;
				for (symbolId in config.extraAnticipation.symbolIdToCount.keys())
				{
					if (!extraAnticipationSymbolCountRevealed.exists(symbolId) ||
					extraAnticipationSymbolCountRevealed.get(symbolId) <
					config.extraAnticipation.symbolIdToCount.get(symbolId))
					{
						anticipate = false;
						break;
					}
				}

				if (anticipate)
				{
					nextReel.setLoopsCountBeforeStop(
						!skip ? config.extraAnticipation.extraSpinLoops :
						config.symbolsOnReelCount
					);

					nextReel.updateSpeedMultiplier();

					if (!_extraAnticipationStarted && !skip)
					{
						_extraAnticipationStarted = true;

						extraAnticipationStarted();
					}
				}
			}

			singleReelAnticipationStarted();
		}
	}

	private function animationCompleted():Void
	{
		_isBusy = false;

		anticipationCompleted();
	}

	private function lastReelViewAnimationStarted(m:IMessage):Void
	{
		lastReelAnimationStarted = true;

		if (appStateModel.state != AppState.RoundStarted)
		{
			prepareToStop();
		}
	}

	private function prepareToStop():Void
	{
		if (!lastReelAnimationStarted) return;

		canSkip = true;

		stopReels();

		anticipationStarted();

		if (autoSkipAfterResponseReceived)
		{
			checkIfCanSkip();
		}
	}

	private function anticipationStarted():Void
	{
		dispatchMessage(ReelsMediatorMessageType.AnticipationStarted);
	}

	private function singleReelAnticipationStarted():Void
	{
		dispatchMessage(ReelsMediatorMessageType.SingleReelAnticipationStarted);
	}

	private function singleReelAnticipationCompleted():Void
	{
		dispatchMessage(ReelsMediatorMessageType.SingleReelAnticipationCompleted);
	}

	private function anticipationCompleted():Void
	{
		dispatchMessage(ReelsMediatorMessageType.AnticipationCompleted);
	}

	private function extraAnticipationStarted():Void
	{
		dispatchMessage(ReelsMediatorMessageType.ExtraAnticipationStarted);
	}

	private function highLightSymbols(value:Bool):Void
	{
		for (reelView in reelViewList)
		{
			reelView.highLightSymbols(value);
		}
	}

	private function highLightSymbolsOnWinLine(index:Int, highLightIterationIndex:Int = 0):Void
	{
		var winModel:ISlotSingleWinModelImmutable = slotWinsModel.slotSingleWinModelList[index];
		var winLineModel:IWinLineModelImmutable = winModel.winLine;

		for (reelView in reelViewList)
		{
			highLighWinLineOnReel(reelView, winLineModel, highLightIterationIndex);
		}
	}

	private function highLighWinLineOnReel(reelView:SingleReelView, winLineModel:IWinLineModelImmutable, highLightIterationIndex:Int):Void
	{
		reelView.highLightSymbols(true, winLineModel != null ? winLineModel.id : -1, highLightIterationIndex);
	}

	private function stopReels():Void
	{
		var extraAnticipationSymbolIdToCountMap:Map<Int, Int> = null;

		if (config.extraAnticipation != null && !skip)
		{
			extraAnticipationSymbolIdToCountMap = new Map<Int, Int>();
		}

		var loopCount:Int = fastPlay ? Std.int(config.loopCount / 2) : config.loopCount;

		for (i in 0...model.singleReelModelListImmutable.length)
		{
			if (extraAnticipationSymbolIdToCountMap != null)
			{
				for (symbolId in config.extraAnticipation.symbolIdToCount.keys())
				{
					var count:Int = model.singleReelModelListImmutable[i].getSymbolCount(symbolId);
					if (count > 0)
					{
						if (!extraAnticipationSymbolIdToCountMap.exists(symbolId))
						{
							extraAnticipationSymbolIdToCountMap.set(symbolId, 0);
						}

						extraAnticipationSymbolIdToCountMap.set(symbolId,
							extraAnticipationSymbolIdToCountMap.get(symbolId) + count);
					}
				}
			}

			reelViewList[i].setLoopsCountBeforeStop(loopCount + (!fastPlay ? loopCount * i : (loopCount != 0) ? i : 0));

			if (extraAnticipationSymbolIdToCountMap != null)
			{
				var anticipate:Bool = true;
				for (symbolId in config.extraAnticipation.symbolIdToCount.keys())
				{
					if (!extraAnticipationSymbolIdToCountMap.exists(symbolId) ||
						extraAnticipationSymbolIdToCountMap.get(symbolId) <
						config.extraAnticipation.symbolIdToCount.get(symbolId))
					{
						anticipate = false;
						break;
					}
				}

				if (anticipate)
				{
					loopCount = 0;
				}
			}
		}
	}

	override private function addListeners():Void
	{
		super.addListeners();

		appStateModel.addMessageListener(StateModelMessageType.StateUpdated, appStateUpdated);

		addMessageListener(WinsMediatorMessageType.SelectedWinUpdated, selectedWinUpdated);
		addMessageListener(WinsMediatorMessageType.ShowAllWinsStarted, handleShowAllWins);
	}

	private function handleShowAllWins(m:IMessage):Void
	{
		for (reelView in reelViewList)
		{
			reelView.combineWinSymbols();
		}
		if (slotWinsModel.count == 1)
		{
			highLightSymbolsOnWinLine(0);
		} else
		if (!config.iterateWinsWhileHighlightingAll)
		{
			for (singleWinModel in slotWinsModel.slotSingleWinModelList)
			{
				highLightSymbolsOnWinLine(slotWinsModel.slotSingleWinModelList.indexOf(singleWinModel));
			}
		}
	}

	private function selectedWinUpdated(m:IMessage):Void
	{
		var singleWinModel:ISlotSingleWinModelImmutable = cast m.data.singleWinModel;
		var highLightIterationIndex:Int = cast m.data.highLightIterationIndex;

		highLightSymbolsOnWinLine(slotWinsModel.slotSingleWinModelList.indexOf(singleWinModel), highLightIterationIndex);
	}

	private function appStateUpdated(m:IMessage):Void
	{
		if (appStateModel.state == AppState.RoundStarted)
		{
			handleRoundStarted();
		} else
		if (appStateModel.state == AppState.ShowingPrevResult)
		{
			handleShowPrevResult();
		} else
		if (appStateModel.state == AppState.ShowingResult)
		{
			handleShowResult();
		}
	}

	private function handleRoundStarted():Void
	{
		trace("handleRoundStarted: " + roundStateModel.state, Trace.INFO);

		showWithAnticipation = roundStateModel.nextState != RoundState.RoundEnd;

		if (roundStateModel.nextState != RoundState.RoundEnd)
		{
			showResult();
		} else
		{
			trace("Round end!", Trace.INFO);
		}
	}

	private function handleShowResult():Void
	{
		trace("handleShowResult: " + roundStateModel.state, Trace.INFO);

		if (showWithAnticipation)
		{
			prepareToStop();
		} else
		{
			showResult();
		}
	}

	private function handleShowPrevResult():Void
	{
		trace("handleShowPrevResult");

		showWithAnticipation = !isShowingPrevFinalResults();

		trace("----------------------------------------------", Trace.INFO);
		trace("appStateModel.state: " + appStateModel.state, Trace.INFO);
		trace("roundStateModel.state: " + roundStateModel.state, Trace.INFO);
		trace("roundStateModel.nextState: " + roundStateModel.nextState, Trace.INFO);
		trace("winsModel.freeGamesWon: " + slotWinsModel.freeGamesWon, Trace.INFO);
		trace("----------------------------------------------", Trace.INFO);
		trace("Show result with anticipation: " + showWithAnticipation, Trace.INFO);
		trace("----------------------------------------------", Trace.INFO);

		showResult();
	}
}

enum ReelsMediatorMessageType
{
	AnticipationStarted;
	AnticipationCompleted;
	SingleReelAnticipationStarted;
	SingleReelAnticipationCompleted;
	ExtraAnticipationStarted;
}
