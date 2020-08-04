package com.cf.casino.models.state;

import com.domwires.core.mvc.model.IModel;
import com.cf.casino.models.state.StateModel;

interface IStateModel extends IStateModelImmutable extends IModel
{
    function setState(value:EnumValue):IStateModel;
    function setNextState(value:EnumValue):IStateModel;
}
