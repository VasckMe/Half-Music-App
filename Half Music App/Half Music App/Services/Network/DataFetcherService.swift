//
//  DataFetcherService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import Foundation
import AlamofireImage

protocol DataFetcherServiceProtocol {
    func fetchFreeMusic(completion: @escaping(Audio?) -> Void)
    func fetchImage(urlString: String, completion: @escaping (Image?) -> Void)
}

final class DataFetcherService: DataFetcherServiceProtocol {
    
    let networkDataFetcher: NetworkDataFetcherProtocol
    
    init(networkDataFetcher: NetworkDataFetcherProtocol = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    func fetchFreeMusic(completion: @escaping (Audio?) -> Void) {
        networkDataFetcher.fetchJSONGenericData(
            urlString: NetworkConstants.apiString,
            headers: NetworkConstants.header,
            response: completion)
    }
    
    func fetchImage(urlString: String, completion: @escaping (Image?) -> Void) {
        networkDataFetcher.fetchURLImageData(urlString: urlString, completion: completion)
    }
}
