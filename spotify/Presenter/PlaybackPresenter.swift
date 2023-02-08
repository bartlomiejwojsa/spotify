//
//  PlaybackPresenter.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 07/02/2023.
//
import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let _ = self.playerQueue, !tracks.isEmpty {
//            let item = self.playerQueue?.currentItem
//            let items = self.playerQueue?.items()
//            guard let index = items?.firstIndex(where: { $0 == item }) else {
//                return nil
//            }

            return tracks[safeIndex]
        }
        return nil
    }
    
    var safeIndex: Int {
        get {
            if self.index >= tracks.count {
                self.index = tracks.count - 1
            } else if self.index < 0 {
                self.index = 0
            }
            return self.index
        }
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    var playerVC: PlayerViewController?
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        print(url)
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.tracks = []
        self.track = track
        let vc = PlayerViewController()
        vc.title = track.name
        vc.playerDataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        self.tracks = tracks
        self.track = nil
        let items: [AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        self.playerQueue = AVQueuePlayer(items: items)
        self.playerQueue?.volume = 0.5
        let vc = PlayerViewController()
        vc.playerDataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.playerQueue?.play()
        }
        self.playerVC = vc
    }
    
}

extension PlaybackPresenter: PlayerDataSource, PlayerViewControllerDelegate {
    func didTapForward() {
        print("tapped forward")
        if tracks.isEmpty {
            player?.pause()
        } else if playerQueue != nil {
            playerQueue?.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        print("tapped backward")
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            let items = playerQueue!.items()
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.volume = 0.5
            playerQueue?.play()
        }
    }
    
    func didTapDismiss() {
        var myPlayer: AVPlayer?
        if let singlePlayer = player {
            myPlayer = singlePlayer
        } else if let multiPlayer = playerQueue {
            myPlayer = multiPlayer
        }
        if let player = myPlayer {
            player.pause()
        }
    }
    
    func didSlideSlider(_ value: Float) {
        if let player = player {
            player.volume = value
        }
    }
    
    func didTapPlayPause() {
        var myPlayer: AVPlayer?
        if let singlePlayer = player {
            myPlayer = singlePlayer
        } else if let multiPlayer = playerQueue {
            myPlayer = multiPlayer
        }
        if let player = myPlayer, player.timeControlStatus == .playing {
            player.pause()
        } else if let player = myPlayer, player.timeControlStatus == .paused {
            player.play()
        }
    }
    
    var songName: String? {
        print(currentTrack?.name)
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
