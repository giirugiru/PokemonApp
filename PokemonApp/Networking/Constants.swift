//
//  Constants.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation

public struct Constants {
    static let shared = Constants()
    
    let baseURL: String = "https://pokeapi.co/api/v2/"
    
    let getPokemon: String = Path.getPokemon.rawValue
    
    enum Path: String {
        case getPokemon = "pokemon/"
    }
}
