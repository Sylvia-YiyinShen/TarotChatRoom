//
//  ChatMemberCell.swift
//  ChatNow
//
//  Created by Zhihui Sun on 21/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit



class ChatMemberImageCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var triangleView: UIImageView!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ChatCellViewModel!
    public func configure(viewModel: ChatCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.username

        if viewModel.username == "Sylvia" {
            profileImage.image = UIImage(named: "female")
        } else {
            profileImage.image = UIImage(named: "male")
        }
        
        activityIndicator.startAnimating()
        viewModel.downloadImage { [weak self] (image) in
            self?.imageMessage.image = image
            self?.imageMessage.backgroundColor = UIColor.clear
            self?.imageMessage.alpha = 1
            self?.activityIndicator.stopAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
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

extension ChatMemberImageCell: Reusable {}
