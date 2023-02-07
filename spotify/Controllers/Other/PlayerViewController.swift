//
//  PlayerViewController.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var playerDataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        configureBarButtons()
        controlsView.delegate = self
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width-20,
            height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15
        )
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction)
        )
    }
    
    private func configure() {
        imageView.sd_setImage(with: playerDataSource?.imageURL)
        controlsView.configure(
            with: PlayerControlsViewViewModel(
                title: playerDataSource?.songName,
                subtitle: playerDataSource?.subtitle
            )
        )

    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapAction() {
        dismiss(animated: true)
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        print("tapped playpause")
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        print("tapped forward")
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        print("tapped  backward")
        delegate?.didTapBackward()
    }
    
    
}
