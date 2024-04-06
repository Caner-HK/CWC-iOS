//
//  AudioPlayerManager.swift
//  CanerWeather
//
//  Created by Kent Ye on 2024/3/2.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    var audioPlayer: AVAudioPlayer?
    
    func playSound(soundFileName: String) {
        guard let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "caf"),
              let sound = URL(string: bundlePath) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("找不到文件或无法播放音频")
        }
    }
}

