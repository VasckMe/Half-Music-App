//
//  AnimationManager.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.11.22.
//

import Foundation
import UIKit

final class AnimationManager {
    
    private init() {}
    
    static let shared = AnimationManager()
    
    func getAnimationImages() -> [UIImage]? {
        var images: [UIImage] = []
        
        for i in 1...4 {
            guard let image = UIImage(named: "AudioBars\(i)") else { return nil }
            images.append(image)
        }
        return images
    }
}
