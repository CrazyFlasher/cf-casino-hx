package com.cf.casino.context;

#if standAlone
import com.ganapati.casino.services.communicator.impl.NativeCommunicatorService;
#elseif html5
#end

import com.cf.devkit.config.IConfig;
import com.cf.devkit.mediators.audio.IAudioMediator;
import com.cf.casino.models.app.IAppModelImmutable;
import com.cf.casino.models.texts.ITextsModelImmutable;
import com.cf.casino.models.win.IWinsModelImmutable;
import com.cf.casino.models.initData.IInitDataModelImmutable;
import com.cf.casino.views.ui.impl.JSUIView;
import com.cf.casino.views.ui.IUIView;
import com.cf.casino.services.communicator.impl.JSCommunicatorService;
import com.cf.casino.config.CasinoConfig;
import com.cf.casino.config.ICasinoConfig;
import com.cf.casino.commands.UpdateFastPlayCommand;
import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.models.state.IStateModelImmutable;
import com.cf.casino.models.payload.IPayloadModelImmutable;
import com.cf.devkit.context.IBaseContext;
import com.cf.casino.commands.InitializeCommand;
import com.cf.casino.models.state.StateModelMessageType;
import com.cf.casino.mediators.ui.IUIMediator;
import com.cf.casino.services.communicator.ICommunicatorService;
import com.cf.casino.models.initData.IInitDataModel;
import com.cf.casino.models.payload.IPayloadModel;
import com.cf.casino.models.win.IWinsModel;
import com.cf.casino.models.app.IAppModel;
import com.cf.casino.models.state.IStateModel;
import com.cf.casino.models.texts.ITextsModel;
import com.cf.devkit.context.BaseContext;
import com.domwires.core.mvc.message.IMessage;

class AbstractCasinoContext extends BaseContext implements IBaseContext
{
    private var casinoConfig:ICasinoConfig;

    private var textsModel:ITextsModel;

    private var appStateModel:IStateModel;
    private var roundStateModel:IStateModel;

    private var appModel:IAppModel;
    private var winsModel:IWinsModel;
    private var payloadModel:IPayloadModel;
    private var initDataModel:IInitDataModel;

    private var comService:ICommunicatorService;

    private var uiMediator:IUIMediator;

    private function new()
    {
        super();
    }

    override private function init():Void
    {
        super.init();

        createUIMediator();

        mapCommands();

        appStateModel.addMessageListener(StateModelMessageType.StateUpdated, appStateChanged);

        executeCommand(InitializeCommand);
    }

    private function createUIMediator():Void
    {
        uiMediator = mediatorFactory.getInstance(IUIMediator);
        mediatorFactory.mapToValue(IUIMediator, uiMediator);

        addMediator(uiMediator);
    }

    override private function createConfig():Void
    {
        super.createConfig();

        casinoConfig = cast appConfig;

        modelFactory.mapToValue(ICasinoConfig, casinoConfig);
        mediatorFactory.mapToValue(ICasinoConfig, casinoConfig);
        viewFactory.mapToValue(ICasinoConfig, casinoConfig);
        factory.mapToValue(ICasinoConfig, casinoConfig);
    }

    override private function createModels():Void
    {
        super.createModels();

        initDataModel = modelFactory.getInstance(IInitDataModel);

        textsModel = modelFactory.getInstance(ITextsModel);
        modelFactory.mapToValue(ITextsModel, textsModel);

        appStateModel = modelFactory.getInstance(IStateModel);
        roundStateModel = modelFactory.getInstance(IStateModel);

        payloadModel = modelFactory.getInstance(IPayloadModel);
        modelFactory.mapToValue(IPayloadModelImmutable, payloadModel);

        modelFactory.mapToValue(IStateModelImmutable, appStateModel, "appStateModel");
        modelFactory.mapToValue(IStateModelImmutable, roundStateModel, "roundStateModel");

        comService = modelFactory.getInstance(ICommunicatorService);

        appModel = modelFactory.getInstance(IAppModel);
        winsModel = modelFactory.getInstance(IWinsModel);

        addModel(textsModel);
        addModel(comService);
        addModel(appModel);
        addModel(appStateModel);
        addModel(roundStateModel);
        addModel(winsModel);
        addModel(payloadModel);
        addModel(initDataModel);
    }

    private function appStateChanged(m:IMessage):Void
    {
        if (appStateModel.state == AppState.AssetsLoaded)
        {
            appStateModel.removeMessageListener(StateModelMessageType.StateUpdated, appStateChanged);

            createMediators();

            executeCommand(UpdateFastPlayCommand, {value: uiMediator.fastPlay});

            screenResizer.update();
        }
    }

    override private function mapTypes():Void
    {
        super.mapTypes();

        modelFactory.mapToType(IConfig, CasinoConfig);
        viewFactory.mapToType(IAudioMediator, com.cf.casino.mediators.audio.AudioMediator);

        #if standAlone
            modelFactory.mapToType(ICommunicatorService, NativeCommunicatorService);
            #if useStarling
            viewFactory.mapToType(IUIView, com.ganapati.casino.views.ui.impl.NativeUIViewStarling);
            #else
            viewFactory.mapToType(IUIView, com.ganapati.casino.views.ui.impl.NativeUIViewOpenFL);
            #end
        #elseif html5
            modelFactory.mapToType(ICommunicatorService, JSCommunicatorService);
            viewFactory.mapToType(IUIView, JSUIView);
        #end

        //TODO: remap if needed
        factory.mapToType(CasinoContextMessagesToCommandsMappings, CasinoContextMessagesToCommandsMappings);
    }

    override private function mapValues():Void
    {
        super.mapValues();

        mediatorFactory.mapToValue(IInitDataModelImmutable, initDataModel);
        mediatorFactory.mapToValue(IWinsModelImmutable, winsModel);
        mediatorFactory.mapToValue(ITextsModelImmutable, textsModel);
        mediatorFactory.mapToValue(IStateModelImmutable, appStateModel, "appStateModel");
        mediatorFactory.mapToValue(IStateModelImmutable, roundStateModel, "roundStateModel");

        mediatorFactory.mapToValue(IPayloadModelImmutable, payloadModel);
        mediatorFactory.mapToValue(IAppModelImmutable, appModel);

        viewFactory.mapToValue(IInitDataModelImmutable, initDataModel);
        viewFactory.mapToValue(ITextsModelImmutable, textsModel);
        viewFactory.mapToValue(IAppModelImmutable, appModel);
        viewFactory.mapToValue(IStateModelImmutable, appStateModel, "appStateModel");
        viewFactory.mapToValue(IStateModelImmutable, roundStateModel, "roundStateModel");
        viewFactory.mapToValue(IWinsModelImmutable, winsModel);
        viewFactory.mapToValue(IPayloadModelImmutable, payloadModel);

        factory.mapToValue(IInitDataModel, initDataModel);
        factory.mapToValue(IAppModel, appModel);
        factory.mapToValue(IStateModel, appStateModel, "appStateModel");
        factory.mapToValue(IStateModel, roundStateModel, "roundStateModel");
        factory.mapToValue(ICommunicatorService, comService);
        factory.mapToValue(IWinsModel, winsModel);
        factory.mapToValue(IPayloadModel, payloadModel);
    }

    private function createMediators():Void
    {
        throw haxe.io.Error.Custom("Game should have at least 1 custom mediator! Override and create in your game context.");
    }

    private function mapCommands():Void
    {
        factory.getInstance(CasinoContextMessagesToCommandsMappings);
    }
}
