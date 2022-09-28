//
//  CacheResponseManager.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.09.22.
//

import Foundation
import AlamofireImage

final class CacheManager {
    
    static let shared = CacheManager()
    
    private init() {}
        
    let urlCache = URLCache(
        memoryCapacity: 0,
        diskCapacity: 100 * 1024 * 1024,
        diskPath: "myChache"
    )
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
}
