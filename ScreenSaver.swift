//
//  ScreenSaver.swift
//  ScreenSaver 1.4
//
//  Created by Đỗ Thái Đôn on 3/9/21.
//

import Foundation
import ScreenSaver
import AVKit

class SaverView: ScreenSaverView {
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
            
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        animationTimeInterval = 1.0/30.0
        wantsLayer = true
        player = createAVPlayer()
        playerLayer = createAVPlayerLayer(player: player)
        self.layer = playerLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        super.startAnimation()
        player.play()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
        player.pause()
    }
        
    func createAVPlayer() -> AVPlayer {
        let saverBundle: Bundle = Bundle(for: SaverView.self)
        guard let url = saverBundle.url(forResource: "ScreenSaver", withExtension: "mov") else {
            fatalError("ScreenSaver.mov not found in \(saverBundle.bundlePath)")
        }
        let avPlayer = AVPlayer(url: url)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        return avPlayer
    }
    
    func createAVPlayerLayer(player: AVPlayer) -> AVPlayerLayer {
        let avPlayerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = bounds
        avPlayerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        avPlayerLayer.needsDisplayOnBoundsChange = true
        avPlayerLayer.contentsGravity = .resizeAspect
        avPlayerLayer.backgroundColor = CGColor(red: 0.00, green: 0.01, blue: 0.00, alpha:1.0)
        return avPlayerLayer
    }
    
    // Notification Handling
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
