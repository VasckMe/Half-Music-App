//
//  Images.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.09.22.
//

import Foundation

struct AlbumImage: Decodable {
//    let height: Int
    let url: String
//    let width: Int
    
    static func convertFromDictionary(dictionary: [String: String]) -> [AlbumImage]? {
        guard
            let bigImageUrl = dictionary["Big image"],
            let mediumImageUrl = dictionary["Medium image"],
            let smallImageUrl = dictionary["Small image"]
        else {
            return nil
        }
        let bigImage = AlbumImage(url: bigImageUrl)
        let mediumImage = AlbumImage(url: mediumImageUrl)
        let smallImage = AlbumImage(url: smallImageUrl)
        return [bigImage, mediumImage, smallImage]
    }
}
