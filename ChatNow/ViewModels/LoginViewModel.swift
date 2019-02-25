//
//  LoginViewModel.swift
//  ChatNow
//
//  Created by Zhihui Sun on 22/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import Foundation

class LoginViewModel {
    private var remoteConfigService: RemoteConfigService
    private var databaseService: DatabaseService<DefaultCodable>
    
    var isShutdown: Bool {
        return remoteConfigService.valueForKey(key: "isShutdown").boolValue
    }
    var shutdownMessage: String? {
        return remoteConfigService.valueForKey(key: "shutdownMessage").stringValue
    }
    
    init(remoteConfigService: RemoteConfigService, databaseService: DatabaseService<DefaultCodable>) {
        self.remoteConfigService = remoteConfigService
        self.databaseService = databaseService
    }
    
    func fetchRemoteConfig(completionHandler: @escaping (() -> Void)) {
        remoteConfigService.fetchRemoteValues {
            completionHandler()
        }
    }
    
    func updateHostStatus(user: String?, isOnline: Bool) {
        guard user == "Sylvia" else { return }
        databaseService.updateValue(key: "isHostOnline", value: isOnline)
    }
}
