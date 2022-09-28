//
//  NetworkService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import Foundation

protocol NetworkServiceProtocol {
    func request(
        urlString: String,
        headers: [String:String]?,
        completion: @escaping (Data?, Error?) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: Internal
    func request(
        urlString: String,
        headers: [String:String]? = nil,
        completion: @escaping (Data?, Error?) -> Void)
    {
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        if headers != nil {
            request.allHTTPHeaderFields = headers
        }
        if let task = createDataTask(with: request, completion: completion) {
            task.resume()
        }
    }
    // MARK: Private
    
    func createSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = CacheResponseManager.shared.cache
        return URLSession(configuration: sessionConfiguration)
    }
    
    func createDataTask(
        with request: URLRequest,
        completion: @escaping (Data?, Error?) -> Void
    ) -> URLSessionDataTask? {
        let session = createSession()
        
        if let cachedData = CacheResponseManager.shared.cache.cachedResponse(for: request) {
            completion(cachedData.data, nil)
            return nil
        } else {
            return session.dataTask(with: request) { data, _, error in
                DispatchQueue.main.async {
                    completion(data, error)
                }
            }
        }
    }
}
