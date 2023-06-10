//
//  APIRequest.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol APIRequest {
    associatedtype Response
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get set }
    var body: [String: Any] { get set }
    var headers: [String: Any] { get set }
    
    func map(_ data: Data) throws -> Response
    
}
