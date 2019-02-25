//
//  ChatMyCell.swift
//  ChatNow
//
//  Created by Zhihui Sun on 21/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit

class ChatMyCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var triangleView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var viewModel: ChatCellViewModel!
    public func configure(viewModel: ChatCellViewModel) {
        self.viewModel = viewModel
        messageLabel.text = viewModel.message
        if viewModel.username == "Sylvia" {
            profileImage.image = UIImage(named: "female")
        } else {
            profileImage.image = UIImage(named: "male")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        let color = UIColor(red: 147/255.0, green: 27/255.0, blue: 47/255.0, alpha: 1.0)
        isUserInteractionEnabled = false
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        triangleView.image = triangleView.image?.withRenderingMode(.alwaysTemplate)
        triangleView.tintColor = color
        messageView.layer.cornerRadius = 8
        messageView.backgroundColor = color
    }
}

extension ChatMyCell: Reusable {}
