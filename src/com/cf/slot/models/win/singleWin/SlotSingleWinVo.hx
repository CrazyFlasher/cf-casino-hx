package com.cf.slot.models.win.singleWin;

import com.cf.slot.models.win.singleWin.winLine.WinLineVo;
import com.cf.casino.models.win.singleWin.SingleWinVo;
import com.domwires.core.utils.ArrayUtils;
import openfl.geom.Point;

class SlotSingleWinVo extends SingleWinVo
{
    public var winLine(get, never):WinLineVo;
    private var _winLine:WinLineVo;

    private var hasWinLine:Bool;

    public var scatterPositionIdList(get, never):Array<Point>;
    private var _scatterPositionIdList:Array<Point> = [];

    override private function init():Void
    {
        super.init();

        createWinLineVo();
    }

    override public function update(winJson:Dynamic, display:Dynamic):Void
    {
        super.update(winJson, display);

        //We also have to support old protocol

        ArrayUtils.clear(_scatterPositionIdList);

        var positionIdListJsonArray:Array<Dynamic> = winJson.positions;

        if (_amount != 0 && (winJson.paylineId != null || winJson.line != null))
        {
            hasWinLine = true;

            _winLine.update(display, positionIdListJsonArray, winJson.paylineId != null ? winJson.paylineId : winJson.line);
        } else
        {
            hasWinLine = false;
        }

        if (!hasWinLine)
        {
            for (scatterPosition in positionIdListJsonArray)
            {
                //TODO: get id from map, take Point from pool
                _scatterPositionIdList.push(new Point(scatterPosition[0], scatterPosition[1]));
            }
        }
    }

    private function createWinLineVo():Void
    {
        _winLine = modelFactory.getInstance(WinLineVo);
    }

    private function get_winLine():WinLineVo
    {
        return hasWinLine ? _winLine : null;
    }

    private function get_scatterPositionIdList():Array<Point>
    {
        return _scatterPositionIdList;
    }
}
