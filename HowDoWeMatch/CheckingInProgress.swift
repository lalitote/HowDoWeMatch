//
//  CheckingInProgress.swift
//  HowDoWeMatch
//
//  Created by lalitote on 07.09.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class CheckingInProgress: UIView
{
    var searchingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var position: CGPoint = CGPoint(x: 100, y: 100)
    
//    class var shared: CheckingInProgress {
//        struct Static {
//            static let instance: CheckingInProgress = CheckingInProgress()
//        }
//        return Static.instance
//    }
    
    func showIndicator(view: UIView) {
        //let width = CGFloat(arc4random()) % view.bounds.width * 0.8
        //let height = CGFloat(arc4random()) % view.bounds.height * 0.8
        //searchingIndicator.center = CGPoint(x: 100, y: 100)
        searchingIndicator.center = position
        searchingIndicator.hidesWhenStopped = true
        searchingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        searchingIndicator.color = UIColor.cyanColor()
        view.addSubview(searchingIndicator)
        searchingIndicator.startAnimating()
    }

    func hideIndicator() {
        searchingIndicator.stopAnimating()
    }
    
}
