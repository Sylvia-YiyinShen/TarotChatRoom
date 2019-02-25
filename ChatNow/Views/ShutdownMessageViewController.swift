//
//  ShutdownMessageViewController.swift
//  ChatNow
//
//  Created by Zhihui Sun on 22/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit

class ShutdownMessageViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    private var message: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 300, height: 300)
        messageLabel.text = message
        
    }
    
    
    func configureMessage(message: String) {
        self.message = message
    }
}

extension ShutdownMessageViewController: PoppableProtocol {}
