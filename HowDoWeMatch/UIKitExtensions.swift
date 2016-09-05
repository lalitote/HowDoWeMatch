//
//  UIKitExtensions.swift
//  HowDoWeMatch
//
//  Created by lalitote on 31.08.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}
