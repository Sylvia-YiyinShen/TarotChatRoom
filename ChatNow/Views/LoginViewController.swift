//
//  LoginViewController.swift
//  ChatNow
//
//  Created by Zhihui Sun on 22/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    private var viewModel: LoginViewModel!
    private var shutdownViewController: ShutdownMessageViewController?
    
    func inject(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkShutdown), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideShutdownPopup), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func hideShutdownPopup() {
        if shutdownViewController != nil {
            shutdownViewController?.dismissAsPopover()
        }
    }
    
    @objc private func checkShutdown() {
        activitiIndicator.startAnimating()
        viewModel.fetchRemoteConfig { [unowned self] in
            if self.viewModel.isShutdown {
                if let message = self.viewModel.shutdownMessage {
                    self.shutdownViewController = ViewControllerFactory.makeShutdownMessageViewController(message: message)
                    self.shutdownViewController?.showAsPopover()
                }
            }
            self.activitiIndicator.stopAnimating()
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureEnterButton()
        viewModel.updateHostStatus(user: userTextField.text, isOnline: false)
    }
    
    private func configureEnterButton() {
        enterButton.layer.cornerRadius = 5
    }
    
    @IBAction func didTapEnterButton(_ sender: Any) {
        let user = (userTextField.text == "" || userTextField.text == nil) ? "Guest" : userTextField.text
        viewModel.updateHostStatus(user: user, isOnline: true)
        let chatRoomViewController = ViewControllerFactory.makeChatRoomViewController(username: user)
        present(UINavigationController(rootViewController: chatRoomViewController), animated: true, completion: nil)
    }
}
