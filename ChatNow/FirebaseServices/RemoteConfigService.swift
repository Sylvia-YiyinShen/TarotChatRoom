//
//  RemoteConfigService.swift
//  ChatNow
//
//  Created by Zhihui Sun on 22/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

class RemoteConfigService {
    static var sharedInstance =  RemoteConfigService()
    private var remoteConfig = RemoteConfig.remoteConfig()
    private init() {}
    
    func valueForKey(key: String) -> RemoteConfigValue {
        return remoteConfig.configValue(forKey: key)
    }
    
    func fetchRemoteValues(fetchCompletionHandler: @escaping (() -> Void)) {
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] (status, error) in
            if let _ = error {
                fetchCompletionHandler()
                return
            }
            self?.remoteConfig.activateFetched()
            fetchCompletionHandler()
        }
    }
}
