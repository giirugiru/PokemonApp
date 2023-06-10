//
//  SearchPokemonRepository.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation
import Combine

internal protocol PokemonDetailRepositoryProtocol {
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, ErrorResponse>
}

internal final class PokemonDetailRepository {
    let network: Networking
    
    init(network: Networking = Networking()) {
        self.network = network
    }
}

extension PokemonDetailRepository: PokemonDetailRepositoryProtocol {
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, ErrorResponse> {
        let request = PokemonDetailRequest(name: name)
        let service = network.request(request)
        return service.asPublisher
    }
}
