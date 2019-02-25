//
//  Protocols.swift
//  ChatNow
//
//  Created by Zhihui Sun on 25/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit

protocol Reusable:  class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nib: UINib? {
        let bundle = Bundle(for: self)
        return UINib(nibName: String(describing: self), bundle: bundle)
    }
}
