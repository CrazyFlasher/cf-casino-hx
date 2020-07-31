package com.cf.casino.services.communicator;

enum CommunicatorMessageType
{
    HandleInit;
    HandleStart;
    HandleRoundStart;
    HandleResult;
    HandlePrevResult;
    HandleUnfinishedGame;
    HandleError;
}
