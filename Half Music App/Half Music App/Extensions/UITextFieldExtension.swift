//
//  TextFieldExtension.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import UIKit

extension UITextField {
    func enablePasswordToggle() {
        let customButton = UIButton()
        customButton.setImage(UIImage(systemName: "eye"), for: .normal)
        customButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        customButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        customButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        rightView = customButton
        rightViewMode = .always
        tintColor = UIConstants.globalTintColor
    }
}

private extension UITextField {
    @objc func togglePassword(customButton: UIButton) {
        isSecureTextEntry.toggle()
        customButton.isSelected.toggle()
    }
}
