//
//  PlaylistViewController.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        loadPlaylist()
        // Do any additional setup after loading the view.
    }
    
    private func loadPlaylist() {
        APICaller.shared.getPlaylistDetails(
            for: self.playlist
        ) { playlistDetails in
            DispatchQueue.main.async {
                switch playlistDetails {
                case .success(let model):
                    print("playlist model: \(model.id)")
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
