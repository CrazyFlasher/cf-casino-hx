package com.cf.casino.models.state.enums;

import haxe.io.Error;

enum RoundState
{
    Play;
    FreePlay;
    RoundEnd;
}

class RoundStateFromString
{
    public static function get(name:String):RoundState
    {
        if (name == "spin" || name == "play") return RoundState.Play;
        if (name == "freespin" || name == "freeplay") return RoundState.FreePlay;
        if (name == "roundend") return RoundState.RoundEnd;
        throw Error.Custom("Unknown name: " + name);
    }
}