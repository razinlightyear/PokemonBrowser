//
//  Pokemon.swift
//  Pokemon Browser
//
//  Created by Andrew Emrazian on 2/20/18.
//  Copyright © 2018 Andrew Emrazian. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let baseExperience: Int
    let types: [PokemonType]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case weight
        case height
        case baseExperience = "base_experience"
        case types
    }
}

struct PokemonType: Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
}
