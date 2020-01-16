//
//  Result.swift
//  Gomez
//
//  Created by Majid Jabrayilov on 7/17/18.
//  Copyright © 2018 snowdog. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

extension Result {
    func resolve() throws -> Value {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

extension Result where Value == Data {
    func decode<T: Decodable>(with decoder: JSONDecoder = JSONDecoder()) throws -> T {
        let data = try resolve()
        return try decoder.decode(T.self, from: data)
    }
}
