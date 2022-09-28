//
//  DataFetcherService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import Foundation
protocol DataFetcherServiceProtocol {
    func fetchFreeMusic(completion: @escaping(Audio?) -> Void)
}

final class DataFetcherService: DataFetcherServiceProtocol {
    
    let networkDataFetcher: NetworkDataFetcherProtocol
    
    init(networkDataFetcher: NetworkDataFetcherProtocol = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    func fetchFreeMusic(completion: @escaping (Audio?) -> Void) {
        networkDataFetcher.fetchJSONGenericData(
            urlString: Constants.apiString,
            headers: Constants.apiHeaders,
            response: completion)
    }
}
