//
//  ViewController.swift
//  musicPlayerAPP
//
//  Created by 羅承志 on 2021/7/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var progressRateSlider: UISlider!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    //AVPlayer 可以播放音訊跟影片，製作一個AVPlayer物件。
    var player = AVPlayer()
    //抓取音樂總長度及播放進度
    var playerItem: AVPlayerItem?
    var playIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileUrl = Bundle.main.url(forResource: "chickBeep", withExtension: ".mp3")!
        playerItem = AVPlayerItem(url: fileUrl)
        songNameLabel.text = "chickBeep"
        singerLabel.text = "王蓉"
        posterImageView.image = UIImage(named: "chick")
    }
    
    //設定音樂時間秒數格式
    func formatConversion(time: Float64) -> String {
        let songLength = Int(time)
        let minutes = Int(songLength / 60)
        let seconds = Int(songLength % 60)
        var time = ""
        if minutes < 10 {
            time = "0\(minutes):"
        } else {
            time = "\(minutes)"
        }
        if seconds < 10 {
            time += "0\(seconds)"
        } else {
            time = time + "\(seconds)"
        }
        return time
    }
    
    //計算當前時間，更新slider跟歌曲目前時間的label
    func CurrentTime() {
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: {(CMTime)in
            if self.player.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player.currentTime())
                self.progressRateSlider.value = Float(currentTime)
                self.currentLabel.text = self.formatConversion(time: currentTime)
            }
        })
    }
    
    func updatePlayerUI() {
        // 把duration轉為我們歌曲的總時間（秒數）
        guard let duration = playerItem?.asset.duration else { return }
        let second = CMTimeGetSeconds(duration)
        totalLabel.text = formatConversion(time: second)
        //如果想要拖動後才更新進度，那就設為 false；如果想要直接更新就設為 true，預設為 true。
        progressRateSlider.minimumValue = 0
        progressRateSlider.maximumValue = Float(second)
        progressRateSlider!.isContinuous = true
    }
    
    @IBAction func progressRate(_ sender: UISlider) {
        let seconds = Int64(progressRateSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player.seek(to: targetTime)
    }
    
    @IBAction func playMusic(_ sender: UIButton) {
        player.replaceCurrentItem(with: playerItem)
        if player.rate == 0 {
            playButton.setImage(UIImage(named: "stop.png"), for: .normal)
            player.play()
        } else {
            playButton.setImage(UIImage(named: "play.png"), for: .normal)
            player.pause()
        }
    }
    
    @IBAction func reverse(_ sender: UIButton) {
        let fileUrl = Bundle.main.url(forResource: "chickBeep", withExtension: "mp3")!
        playerItem = AVPlayerItem(url: fileUrl)
        posterImageView.image = UIImage(named: "chick.jpg")
        songNameLabel.text = "chickBeep"
        singerLabel.text = "王蓉"
        updatePlayerUI()
        CurrentTime()
        player.replaceCurrentItem(with: playerItem)
    }
    
    @IBAction func fastForward(_ sender: UIButton) {
        let fileUrl = Bundle.main.url(forResource: "babyShark", withExtension: "mp3")!
        playerItem = AVPlayerItem(url: fileUrl)
        posterImageView.image = UIImage(named: "babyShark.jpg")
        songNameLabel.text = "babyShark"
        singerLabel.text = "babyShark"
        updatePlayerUI()
        CurrentTime()
        player.replaceCurrentItem(with: playerItem)
    }
}

