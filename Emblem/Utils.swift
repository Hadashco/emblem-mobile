//
//  Utils.swift
//  Emblem
//
//  Created by Dane Jordan on 8/25/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import Foundation

class Utils {
    class func genLoadingScreen(width: CGFloat, height: CGFloat, loadingText: String) -> UIView {
        let indicatorWidth:CGFloat = 20
        let indicatorHeight:CGFloat = 20
        let backgroundLoadingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let indicatorFrame = CGRectMake((width - indicatorWidth) / 2, height  / 2 - indicatorHeight, indicatorWidth, indicatorHeight)
        let loadingIndicator = UIActivityIndicatorView(frame: indicatorFrame)
        let loadingFrame = CGRectMake(0, indicatorHeight, width, height)
        let loadingLabel = UILabel(frame: loadingFrame)
        
        loadingLabel.text = loadingText
        loadingLabel.numberOfLines = 0
        loadingLabel.font = UIFont(name: "OpenSansLight-Italic", size: 14)
        loadingLabel.textAlignment = .Center
        loadingIndicator.color = .blackColor()
        loadingIndicator.startAnimating()
        
        let backgroundWhiteView = UIView(frame: CGRectMake(0,0, width, height))
        backgroundWhiteView.layer.opacity = 0.7
        backgroundWhiteView.backgroundColor = .whiteColor()
        backgroundLoadingView.addSubview(backgroundWhiteView)
        backgroundLoadingView.addSubview(loadingLabel)
        backgroundLoadingView.addSubview(loadingIndicator)
        return backgroundLoadingView
    }
}

extension String {
    func sha256() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA256(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map {String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
}