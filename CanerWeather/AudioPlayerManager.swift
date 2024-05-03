//
//  AudioPlayerManager.swift
//  CanerWeather
//
//  Created by Kent Ye on 2024/3/2. Edited by Kent Ye on 2024/5/3.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    var audioPlayer: AVAudioPlayer?
    
    init() {
        setupAudioSession()
    }

    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("设置音频会话失败：\(error)")
        }
    }

    func playSound(soundFileName: String) {
        // 确保资源名正确，且文件类型后缀正确
        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: "caf") else {
            print("找不到文件或无法创建URL")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("找不到文件或无法播放音频")
        }
    }
}
