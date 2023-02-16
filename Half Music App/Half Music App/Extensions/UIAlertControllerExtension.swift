//
//  UIAlertControllerExtension.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 2.11.22.
//

import UIKit

extension UIAlertController {
    func setBackgroundColor(color: UIColor) {
        if
            let bgView = self.view.subviews.first,
            let groupView = bgView.subviews.first,
            let contentView = groupView.subviews.first
        {
            contentView.backgroundColor = color
        }
    }

    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font: titleFont],
                                          range: NSMakeRange(0, title.utf8.count))
        }

        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: titleColor],
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")
    }

    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font: messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }

        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }

    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
