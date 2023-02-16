//
//  VerificationService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 1.10.22.
//

import Foundation

final class VerificationService {
    
    static let badRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
    static let notBadRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$"
    static let notGoodRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}$"
    static let goodRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
    
    static func isValidEmailAddress(emailAddressString: String?) -> Bool {
        let emailAddress = emailAddressString ?? ""
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddress as NSString
            let results = regex.matches(
                in: emailAddress,
                range: NSRange(location: 0, length: nsString.length)
            )
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    static func isValidPassword(password: String?) -> PasswordDifficult {
        let pass = password ?? ""
        if NSPredicate(format: "SELF MATCHES %@", goodRegex).evaluate(with: pass) {
            return .good
        } else if NSPredicate(format: "SELF MATCHES %@", notGoodRegex).evaluate(with: pass) {
            return .notGood
        } else if NSPredicate(format: "SELF MATCHES %@", notBadRegex).evaluate(with: pass) {
            return .notBad
        } else if NSPredicate(format: "SELF MATCHES %@", badRegex).evaluate(with: pass) {
            return .bad
        } else {
            return .bad
        }
    }
        
    static func isPasswordConfirm(password: String?, confPassword: String?) -> Bool {
        guard
            let password = password,
            let confPassword = confPassword
        else {
            return false
        }
        return password == confPassword
    }
}
