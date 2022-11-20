//
//  NetworkService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import Foundation
import Alamofire
import AlamofireImage

protocol NetworkServiceProtocol {
    func request(
        urlString: String,
        headers: [String:String]?,
        completion: @escaping (Data?, Error?) -> Void
    )
    func requestImage(url: URLConvertible, completion: @escaping(AFDataResponse<Image>) -> Void)
    func requestImageFromCache(url: String) -> Image?
}

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Internal
    
    func request(
        urlString: String,
        headers: [String: String]? = nil,
        completion: @escaping (Data?, Error?) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            return
        }

        let cache = ResponseCacheManager.shared.urlCache
        
        let defaultRequest = URLRequest(url: url)
        
        let httpHeaders = headers != nil ? HTTPHeaders(headers!) : nil
        
        if let cachedData = cache.cachedResponse(for: defaultRequest) {
            completion(cachedData.data, nil)
        } else {
            AF.request(url,
                       method: .get,
                       encoding: JSONEncoding.default,
                       headers: httpHeaders
            ).response { response in
                
                var dataValue: Data?
                var err: Error?
                
                switch response.result {
                case .success(let data):
                    dataValue = data
                    let cachedData = CachedURLResponse(response: response.response!, data: dataValue!)
                    cache.storeCachedResponse(cachedData, for: defaultRequest)
                case .failure(let error):
                    err = error
                }
                
                DispatchQueue.main.async {
                    completion(dataValue, err)
                }
            }
        }
    }
    
    func requestImage(url: URLConvertible, completion: @escaping(AFDataResponse<Image>) -> Void) {
        AF.request(url).responseImage { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func requestImageFromCache(url: String) -> Image? {
        ImageCacheManager.shared.imageCache.image(withIdentifier: url)
    }
}
