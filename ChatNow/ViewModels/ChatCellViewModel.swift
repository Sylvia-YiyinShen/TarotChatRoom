//
//  ChatCellViewModel.swift
//  ChatNow
//
//  Created by Zhihui Sun on 21/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//
import Foundation
import UIKit

class ChatCellViewModel {
    private var model: MessageModel
    private var storageService: StorageService
    
    public var isImageType: Bool {
        return true
    }
    
    public var imagePath: String {
        return model.imagePath ?? ""
    }
    
    public var username: String {
        return model.username ?? ""
    }
    public var message: String {
        return model.message ?? ""
    }
    
    public func downloadImage(completionHandler: @escaping ((UIImage) -> Void)) {
        guard let imagePath = model.imagePath, imagePath != "" else { return }
        storageService.downloadImage(imagePath: imagePath) { (image) in
            completionHandler(image)
        }
    }
    
    init(model: MessageModel, storageService: StorageService) {
        self.model = model
        self.storageService = storageService
    }
}
