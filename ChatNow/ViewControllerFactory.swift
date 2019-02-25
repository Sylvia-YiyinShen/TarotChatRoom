//
//  ViewControllerFactory.swift
//  ChatNow
//
//  Created by Zhihui Sun on 22/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import Foundation

class ViewControllerFactory {
    static func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel(remoteConfigService: RemoteConfigService.sharedInstance, databaseService: DatabaseService(databaseName: "RoomStatus"))
        let loginViewController = LoginViewController()
        loginViewController.inject(viewModel: viewModel)
        return loginViewController
    }
    
    static func makeChatRoomViewController(username: String?) -> ChatRoomViewController {
        let chatRoomViewController = ChatRoomViewController()
        let chatRoomViewModel = ChartRoomViewModel(username: username ?? "Guest",databaseService: DatabaseService(databaseName: "TarotRoom"), storageService: StorageService(storageDir: "TarotRoom"))
        chatRoomViewController.inject(viewModel: chatRoomViewModel)
        return chatRoomViewController
    }
    
    static func makeShutdownMessageViewController(message: String) -> ShutdownMessageViewController {
        let shutdownViewController = ShutdownMessageViewController()
        shutdownViewController.configureMessage(message: message)
        return shutdownViewController
    }
}
