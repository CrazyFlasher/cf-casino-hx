package com.cf.casino.models.win.singleWin;

@:keep
class SingleWinModel extends AbstractAppModelContainer implements ISingleWinModel
{
    public var isBusy(get, never):Bool;

    private var _isBusy:Bool = false;

    private var vo:SingleWinVo;

    public var amount(get, never):Float;
    public var count(get, never):Int;
    public var multiplier(get, never):Int;
    public var symbolId(get, never):Int;
    public var freeGamesAwarded(get, never):Int;

    public var hasHighSymbol(get, never):Bool;

    public function update(vo:SingleWinVo):ISingleWinModel
    {
        this.vo = vo;

        _isBusy = true;

        return this;
    }

    override private function removedFromHierarchy():Void
    {
        _isBusy = false;

        super.removedFromHierarchy();
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
        return vo.amount;
    }

    private function get_count()
    {
        return vo.count;
    }

    private function get_multiplier()
    {
        return vo.multiplier;
    }

    private function get_symbolId()
    {
        return vo.symbolId;
    }

    private function get_freeGamesAwarded():Int
    {
        return vo.freeGamesAwarded;
    }

    private function get_hasHighSymbol():Bool
    {
        return vo.hasHighSymbol;
    }
}
