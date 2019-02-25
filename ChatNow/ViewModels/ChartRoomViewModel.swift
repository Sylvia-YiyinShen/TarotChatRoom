//
//  ChartRoomViewModel.swift
//  ChatNow
//
//  Created by Zhihui Sun on 21/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MessageModel: DatabaseCodable {
    var username: String?
    var message: String?
    var imagePath: String?
    var messageType: Bool
    
    init(snapshot: DataSnapshot) {
        let dictionary = snapshot.value as? NSDictionary
        username = dictionary?["id"] as? String
        message = dictionary?["msg"] as? String
        imagePath = dictionary?["img"] as? String
        messageType = dictionary?["mType"] as? Bool ?? true
    }
    
    func convertToDictionary() -> Any {
        let messageData: [String : Any] = ["id": username ?? "",
                                              "msg": message ?? "",
                                              "img": imagePath ?? "",
                                              "mType": messageType]
        return messageData
    }
    
    init(username: String, message: String, imagePath: String, messageType: Bool = true) {
        self.username = username
        self.message = message
        self.imagePath = imagePath
        self.messageType = messageType
    }
    
}

class ChartRoomViewModel {
    private let mockMode = false
    private let databaseService: DatabaseService<MessageModel>
    private let storageService: StorageService
    private let userName: String
    public var refreshUIHandler: (() -> Void)?
    
    init(username: String, databaseService: DatabaseService<MessageModel>, storageService: StorageService
        ) {
        self.userName = username
        self.databaseService = databaseService
        self.storageService = storageService
    }
    
    private var tarotRoomMessages: [MessageModel] = []
    
    public func isMyMessage(at index: Int) -> Bool {
        return messageModel(at: index).username == userName
    }
    
    public func isImageType(at index: Int) -> Bool {
        return messageModel(at: index).messageType == false
    }
    
    public func uploadImageMessage(image: UIImage, imageName: String) {
        let key = sendImage()
        storageService.uploadImage(image: image, imageName: imageName) { [weak self](imageName) in
            self?.updateImage(key: key, imageName: imageName)
        }
    }
    
    public func numberOfMessages() -> Int {
        return tarotRoomMessages.count
    }
    
    public func messageCellViewModel(at index: Int) -> ChatCellViewModel {
        return ChatCellViewModel(model: tarotRoomMessages[index], storageService: storageService)
    }
    
    private func messageModel(at index: Int) -> MessageModel {
        return tarotRoomMessages[index]
    }
    
    public func messageTextColor(model: MessageModel) -> UIColor {
        if model.username == userName {
            return UIColor.blue
        } else {
            return UIColor.black
        }
    }
    
    public func observeMessage() {
        if mockMode {
            mockMessages()
        } else {
            observeMessages()
        }
    }
    
    private func mockMessages() {
        let message1 = MessageModel(username: "Robin", message: "Hi Sylvia", imagePath: "")
        let message2 = MessageModel(username: "Sylvia", message: "Hi, how are you", imagePath: "")
        tarotRoomMessages = [message1, message2]
        refreshUIHandler?()
    }
    
    private func observeMessages() {
        databaseService.observeValues { [unowned self] (records) in
            self.tarotRoomMessages = records
            self.refreshUIHandler?()
        }
    }
    
    private func generateKeyForMessage() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        return formatter.string(from: Date())
    }
    
    private func sendMessageToDatabase(message: String) {
        let date = generateKeyForMessage()
        let newMessage = MessageModel(username: userName, message: message, imagePath: "", messageType: true)
        databaseService.addRecord(key: date, value: newMessage)
    }
    
    private func mockSendMessage(message: String) {
        tarotRoomMessages.append(MessageModel(username: userName, message: message, imagePath: ""))
        refreshUIHandler?()
    }
    
    public func sendMessage(message: String) {
        if mockMode {
            mockSendMessage(message: message)
        } else {
            sendMessageToDatabase(message: message)
        }
    }
    
    public func sendImage() -> String {
        let key = generateKeyForMessage()
        let newMessage = MessageModel(username: userName, message: "", imagePath: "", messageType: false)
        databaseService.addRecord(key: key, value: newMessage)
        return key
    }
    
    public func updateImage(key: String, imageName: String) {
        let newMessage = MessageModel(username: userName, message: "", imagePath: String("\(imageName).png"), messageType: false)
        databaseService.addRecord(key: key, value: newMessage)
    }
}
