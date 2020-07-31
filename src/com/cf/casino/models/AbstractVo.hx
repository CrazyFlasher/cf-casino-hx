package com.cf.casino.models;

import com.domwires.core.factory.IAppFactory;
import hex.di.IInjectorContainer;

class AbstractVo implements IInjectorContainer
{
    @Inject("modelFactory")
    private var modelFactory:IAppFactory;

    @PostConstruct
    private function init():Void
    {

    }
}
