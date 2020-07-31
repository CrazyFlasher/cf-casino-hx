package com.cf.casino.models.win.singleWin;

@:keep
class SingleWinVo extends AbstractVo
{
    public var isBusy(get, set):Bool;

    private var _isBusy:Bool = false;

    public var amount(get, never):Float;
    public var count(get, never):Int;
    public var multiplier(get, never):Int;
    public var symbolId(get, never):Int;
    public var freeGamesAwarded(get, never):Int;

    public var hasHighSymbol(get, never):Bool;

    private var _amount:Float;
    private var _count:Int;
    private var _multiplier:Int;

    private var _symbolId:Int;
    private var _freeGamesAwarded:Int = 0;

    public function update(winJson:Dynamic, display:Dynamic):Void
    {
        //We also have to support old protocol

        _amount = winJson.amount;
        _count = winJson.count;
        _multiplier = winJson.multiplier;

        if (winJson.freeGamesAwarded != null)
        {
            _freeGamesAwarded = winJson.freeGamesAwarded;
        } else
        {
            _freeGamesAwarded = 0;
        }

        _symbolId = winJson.symbol != null ? winJson.symbol : winJson.item;
    }

    private function get_isBusy():Bool
    {
        return _isBusy;
    }

    private function set_isBusy(value:Bool):Bool
    {
        return _isBusy = value;
    }

    private function get_amount()
    {
        return _amount;
    }

    private function get_count()
    {
        return _count;
    }

    private function get_multiplier()
    {
        return _multiplier;
    }

    private function get_symbolId()
    {
        return _symbolId;
    }

    private function get_freeGamesAwarded():Int
    {
        return _freeGamesAwarded;
    }

    private function get_hasHighSymbol():Bool
    {
        return _symbolId < 5;
    }
}
