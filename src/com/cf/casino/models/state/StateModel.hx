package com.cf.casino.models.state;

import com.domwires.core.mvc.model.AbstractModel;

@:keep
class StateModel extends AbstractModel implements IStateModel
{
    public var state(get, never):EnumValue;
    public var nextState(get, never):EnumValue;
    public var prevState(get, never):EnumValue;

    private var _state:EnumValue;
    private var _nextState:EnumValue;
    private var _prevState:EnumValue;

    public function setState(value:EnumValue):IStateModel
    {
        _prevState = _state;

        if (_state != value)
        {
            _state = value;

            dispatchMessage(StateModelMessageType.StateUpdated);
        }

        return this;
    }

    public function setNextState(value:EnumValue):IStateModel
    {
        if (_nextState != value)
        {
            _nextState = value;

            dispatchMessage(StateModelMessageType.NextStateUpdated);
        }

        return this;
    }

    private function get_state():EnumValue
    {
        return _state;
    }

    private function get_nextState():EnumValue
    {
        return _nextState;
    }

    private function get_prevState():EnumValue
    {
        return _prevState;
    }
}
