//
//  NetworkDataFetcher.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import Foundation
import Alamofire
import AlamofireImage

protocol NetworkDataFetcherProtocol {
    func fetchJSONGenericData<T: Decodable>(
        urlString: String,
        headers: [String : String]?,
        response: @escaping(T?) -> Void
    )
    func fetchURLImageData(urlString: String, completion: @escaping (Image?) -> Void)
}

final class NetworkDataFetcher: NetworkDataFetcherProtocol {
    
    let networkService: NetworkServiceProtocol
    
    // MARK: - Life Cycle
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Internal
    
    func fetchJSONGenericData<T: Decodable>(
        urlString: String,
        headers: [String : String]? = nil,
        response: @escaping(T?) -> Void
    ) {
        networkService.request(urlString: urlString, headers: headers) { data, error in
            if let error = error {
                print("Fetch error - \(error)")
                response(nil)
            } else {
                let decodedModel = self.decodeJSON(type: T.self, data: data)
                response(decodedModel)
            }
        }
    }
    
    func fetchURLImageData(urlString: String, completion: @escaping (Image?) -> Void) {
        if let image = networkService.requestImageFromCache(url: urlString) {
            completion(image)
        } else {
            networkService.requestImage(url: urlString) { response in
                switch response.result {
                case .failure(let error):
                    print("Error \(error)")
                case .success(let image):
                    ImageCacheManager.shared.imageCache.add(image, withIdentifier: urlString)
                    completion(image)
                }
            }
        }
    }
    
    // MARK: - Private
    
    func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else {
            return nil
        }
        do {
            let model = try decoder.decode(type.self, from: data)
            return model
        } catch {
            print("Decoding error - \(error)")
            return nil
        }
    }
}
