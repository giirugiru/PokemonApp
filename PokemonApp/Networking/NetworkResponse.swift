//
//  NetworkResponse.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation
import Combine

public enum NetworkErrorType: Error {
    case noInternet
    case errorResponse
    case invalidResponse
    case noData
    case serializationError
    case failedResponse
    case refreshTokenFailed
    case cancelled
}

public struct ErrorResponse: Error {
    public let type: NetworkErrorType
    public let message: String
    public let code: Int
}

public enum NetworkResponse<T> {
    case success(T)
    case failure(ErrorResponse)
    
    public var asPublisher: AnyPublisher<T, ErrorResponse> {
        Future { resolve in
            switch self {
            case let .success(data):
                resolve(.success(data))
            case let .failure(error):
                resolve(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
