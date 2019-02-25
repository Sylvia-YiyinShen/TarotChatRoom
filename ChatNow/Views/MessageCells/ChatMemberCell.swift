//
//  ChatMemberCell.swift
//  ChatNow
//
//  Created by Zhihui Sun on 21/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit



class ChatMemberCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var triangleView: UIImageView!
    
    private var viewModel: ChatCellViewModel!
    public func configure(viewModel: ChatCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.username
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
        // Initialization code
    }
    
    private func configureViews() {
        isUserInteractionEnabled = false
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        triangleView.image = triangleView.image?.withRenderingMode(.alwaysTemplate)
        messageView.layer.cornerRadius = 8
    }
}

extension ChatMemberCell: Reusable {}
