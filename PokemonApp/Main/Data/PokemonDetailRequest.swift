//
//  PokemonDetailRequest.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation

internal struct PokemonDetailRequest: APIRequest {
    typealias Response = PokemonDetailModel
    
    var baseURL: String = Constants.shared.baseURL
    
    var method: HTTPMethod = .get
    
    var path: String = Constants.shared.getPokemon
    
    var body: [String : Any] = [:]
    
    var headers: [String : Any] = [:]
    
    init(name: String) {
        path += name
    }
    
    func map(_ data: Data) throws -> PokemonDetailModel {
        let decoded = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
        return decoded.toDomain()
    }
}
