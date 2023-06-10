//
//  Networking.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation

public final class Networking: NSObject {
    var service: URLSession = .shared
    
    public override init() {
        super.init()
        self.service = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    }
}

extension Networking {
    public func request<T: APIRequest>(_ request: T) -> NetworkResponse<T.Response> {
        let semaphore = DispatchSemaphore(value: 0)
        var responseResult: NetworkResponse<T.Response> = .failure(ErrorResponse(type: .cancelled, message: "Request cancelled", code: -1000))
        
        guard let urlRequest = createURLRequest(from: request) else {
            responseResult = .failure(ErrorResponse(type: .invalidResponse, message: "Failed to create URL Request", code: -1001))
            return responseResult
        }
        
        let task = service.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            responseResult = self.responseHandler(data: data, response: response, error: error, request: request)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        return responseResult
    }
    
    private func responseHandler<T: APIRequest>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        request: T
    ) -> NetworkResponse<T.Response> {
        
        guard let data = data else {
            return .failure(ErrorResponse(
                type: .noData,
                message: "No data received",
                code: -1002))
        }
        
        guard let response = response as? HTTPURLResponse else {
            return .failure(ErrorResponse(
                type: .failedResponse,
                message: "Failed to generate response",
                code: -1003))
        }
        
        guard 200..<300 ~= response.statusCode else {
            return .failure(ErrorResponse(
                type: .errorResponse,
                message: response.description,
                code: response.statusCode))
        }
        
        do {
            let result = try request.map(data)
            return .success(result)
        } catch {
            return .failure(ErrorResponse(
                type: .serializationError,
                message: error.localizedDescription,
                code: -1004))
        }
    }
    
    private func createURLRequest<T: APIRequest>(from request: T) -> URLRequest? {
        let urlString = request.baseURL + request.path
        guard let url = URL(string: urlString) else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
}
