//
//  PokemonDetailUseCase.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation
import Combine

protocol PokemonDetailUseCaseProtocol {
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, ErrorResponse>
}

internal final class PokemonDetailUseCaseDefault {
    let repository = PokemonDetailRepository()
}

extension PokemonDetailUseCaseDefault: PokemonDetailUseCaseProtocol {
    func getPokemonDetail(name: String) -> AnyPublisher<PokemonDetailModel, ErrorResponse> {
        return repository.getPokemonDetail(name: name)
    }
}
