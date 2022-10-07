//
//  ResponseCacheManager.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import Foundation

final class ResponseCacheManager {
    
    static let shared = ResponseCacheManager()
    
    private init() {}
    
    let urlCache = URLCache(
        memoryCapacity: 0,
        diskCapacity: 100 * 1024 * 1024,
        diskPath: "myChache"
    )
}
