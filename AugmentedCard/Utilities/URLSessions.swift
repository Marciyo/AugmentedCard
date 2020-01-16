//
//  URLSessions.swift
//  PromiseKitAPI
//
//  Created by Artur Chabera on 22/01/2019.
//  Copyright © 2019 Artur Chabera. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}

protocol Request {
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    var body: [String: Any]? { get }
    var baseURLString: String { get }
    var apiKey: String { get }
}

extension Request {
    var body: [String: Any]? {
        return nil
    }

    var baseURLString: String {
        guard let baseUrl = Bundle.main.infoDictionary!["ServerURL"] as? String else {
            fatalError("Please add ServerURL to Info.plist")
        }
        return baseUrl
    }

    var apiKey: String {
        guard let key = Bundle.main.infoDictionary!["APIKey"] as? String else {
            fatalError("Please add APIKey to Info.plist")
        }
        return key
    }
}

extension URLSession {
    func dataTask(with request: Request, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: prepareUrlRequest(from: request), completionHandler: completionHandler)
    }

    func dataTask<T: Decodable>(with request: Request, decoder: JSONDecoder, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: prepareUrlRequest(from: request)) { (data, response, error) in
            if let data = data {
                do {
                    let json = try decoder.decode(T.self, from: data)
                    completionHandler(json, response, error)
                } catch {
                    completionHandler(nil, response, error)
                }
            } else {
                completionHandler(nil, response, error)
            }
        }
    }

    private func prepareUrlRequest(from request: Request) -> URLRequest {
        guard var urlComponents = URLComponents(url: request.url, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create url components from url: \(request.url.absoluteString)")
        }

        var queryItems: [URLQueryItem] = []

        request.parameters?.forEach { (key, value) in
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            fatalError("Couldn't create url with these parameters")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        request.headers?.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        if let body = request.body, let json = try? JSONSerialization.data(withJSONObject: body, options: []) {
            urlRequest.httpBody = json

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return urlRequest
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

