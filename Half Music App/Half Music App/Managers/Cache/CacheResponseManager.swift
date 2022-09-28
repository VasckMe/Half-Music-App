//
//  CacheResponseManager.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.09.22.
//

import Foundation



final class CacheResponseManager {
    
    static let shared = CacheResponseManager()
    
    private init() {}
        
    let cache = URLCache(
        memoryCapacity: 0,
        diskCapacity: 100 * 1024 * 1024,
        diskPath: "myChache"
    )
}
