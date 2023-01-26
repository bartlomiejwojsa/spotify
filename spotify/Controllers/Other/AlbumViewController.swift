//
//  AlbumViewController.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 22/11/2022.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        loadAlbum()
    }
    
    private func loadAlbum() {
        APICaller.shared.getAlbumDetails(
            for: self.album
        ) { albumDetails in
            DispatchQueue.main.async {
                switch albumDetails {
                case .success(let model):
                    print("album model: \(model.id)")
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
