//
//  Album.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.09.22.
//

import Foundation

struct Album: Decodable {
    let images: [Images]
    let name: String
}
