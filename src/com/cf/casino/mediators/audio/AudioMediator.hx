package com.cf.casino.mediators.audio;

import com.domwires.core.mvc.message.IMessage;
import com.cf.casino.mediators.ui.UIMediatorMessageType;

class AudioMediator extends com.cf.devkit.mediators.audio.AudioMediator
{
    override private function addListeners():Void
    {
        super.addListeners();

        addMessageListener(UIMediatorMessageType.MusicVolumeUpdate, onMusicVolumeUpdate);
        addMessageListener(UIMediatorMessageType.SoundVolumeUpdate, onSoundVolumeUpdate);
    }

    private function onMusicVolumeUpdate(m:IMessage):Void
    {
        var volume:Float = m.data.volume;
        setMasterMusicVolume(volume);
    }

    private function onSoundVolumeUpdate(m:IMessage):Void
    {
        var volume:Float = m.data.volume;
        setMasterSoundVolume(volume);
    }
}
