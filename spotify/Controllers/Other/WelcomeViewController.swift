//
//  WelcomeViewController.swift
//  spotify
//
//  Created by Bartłomiej Wojsa on 04/11/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    private var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
//    private var signInButton2: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        button.setTitle("sdadsa", for: .normal)
//        button.setTitleColor(.blue, for: .normal)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemGreen
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(signInButton)
        // this add only subview for button which is view but it has empty frame on startup -> need to setup
//        view.addSubview(signInButton2)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .systemGreen
        title = "Spotify"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
        //add some another button attempt
//        signInButton2.frame = CGRect(
//            x: 20,
//            y: view.height-110-view.safeAreaInsets.bottom,
//            width: view.width-40,
//            height: 50
//        )
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            // check if self is not nil
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // log user in or yell at them for error
        guard success else {
            let alert = UIAlertController(
                title: "Wooopss",
                message: "Something went wrong when signing in",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        print("handle sign in\(success)")
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}
