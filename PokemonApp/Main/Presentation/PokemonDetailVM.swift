//
//  PokemonDetailVM.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation
import Combine

internal final class PokemonDetailVM {
    let useCase = PokemonDetailUseCaseDefault()
}

internal extension PokemonDetailVM {
    
    struct Input {
        let getPokemonDetail: AnyPublisher<String, Error>
    }
    
    class Output {
        @Published var model: PokemonDetailModel?
        @Published var isLoading: Bool = false
        @Published var errorCode: Int?
    }
    
    func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.getPokemonDetail
            .map { s in
                output.isLoading = true
                return s
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .flatMap { param in
                self.useCase.getPokemonDetail(name: param)
                    .map { Result.success($0) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("SUCCES")
                case .failure(let error):
                    dump(error)
                }
            }, receiveValue: { result in
                output.isLoading = false
                switch result {
                case .success(let data):
                    output.model = data
                case .failure(let error):
                    dump(error)
                    output.errorCode = error.code
                }
            })
            .store(in: &cancellables)
        
        return output
    }
}
