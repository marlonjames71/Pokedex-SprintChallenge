//
//  Pokemon.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


struct Pokemon: Codable, Equatable {
	let abilities: [Ability]
	let id: Int
	let types: [TypeElement]
	let name: String
	let sprites: [String : URL]
}

struct Ability: Codable, Equatable {
	let ability: Species
}

struct Species: Codable, Equatable {
	let name: String
}

//struct Sprites: Codable, Equatable {
//	let frontDefault, frontShiny, frontFemale, frontShinyFemale : String
//	let backDefault, backShiny, backFemale, backShinyFemale: String
//
//	enum CodingKeys: String, CodingKey {
//		case backDefault = "back_default"
//		case backFemale = "back_female"
//		case backShiny = "back_shiny"
//		case backShinyFemale = "back_shiny_female"
//		case frontDefault = "front_default"
//		case frontFemale = "front_female"
//		case frontShiny = "front_shiny"
//		case frontShinyFemale = "front_shiny_female"
//	}
//}

struct TypeElement: Codable, Equatable {
	let type: Species
}
