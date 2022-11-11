//
//  VCRepresentation.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 11.11.22.
//

import Foundation
import SwiftUI

struct ViewControllerRepresentation: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("update")
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! CustomTabBarController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        return vc
    }
}
