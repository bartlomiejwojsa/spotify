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
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    var player: AVPlayer?
    
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
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        self.tracks = tracks
        self.track = nil
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
}

extension PlaybackPresenter: PlayerDataSource, PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        if let player = player {
            player.volume = value
        }
    }
    
    func didTapPlayPause() {
        if let player = player, player.timeControlStatus == .playing {
            player.pause()
        } else if let player = player, player.timeControlStatus == .paused {
            player.play()
        }
    }
    
    func didTapForward() {
        print("tapped forward")
        if tracks.isEmpty {
            player?.pause()
        } else {
            
        }
    }
    
    func didTapBackward() {
        print("tapped backward")
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else {
            
        }
    }
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
