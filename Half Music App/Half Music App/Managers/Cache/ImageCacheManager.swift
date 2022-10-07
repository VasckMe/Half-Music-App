//
//  ImageCacheManager.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import Foundation
import AlamofireImage

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private init() {}
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
}
