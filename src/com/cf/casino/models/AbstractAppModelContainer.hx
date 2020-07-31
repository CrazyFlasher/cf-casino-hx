package com.cf.casino.models;

import com.domwires.core.factory.IAppFactory;
import com.domwires.core.mvc.model.ModelContainer;

class AbstractAppModelContainer extends ModelContainer
{
    @Inject("modelFactory")
    private var modelFactory:IAppFactory;

    @PostConstruct
    private function init():Void
    {

    }
}
