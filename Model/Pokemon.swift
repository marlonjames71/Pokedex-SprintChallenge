//
//  Pokemon.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


struct Pokemon: Codable {
	let abilities: [Ability]
	let id: Int
	let types: [TypeElement]
	let name: String
}

struct Ability: Codable {
	let ability: Species
}

struct Species: Codable {
	let name: String
}

struct Sprites: Codable {
	let backDefault: URL?
	let backFemale: URL?
	let backShiny: URL?
	let backShinyFemale: URL?
	let frontDefault: URL?
	let frontFemale: URL?
	let frontShiny: URL?
	let frontShinyFemale: URL?

	enum CodingKeys: String, CodingKey {
		case backDefault = "back_default"
		case backFemale = "back_female"
		case backShiny = "back_shiny"
		case backShinyFemale = "back_shiny_female"
		case frontDefault = "front_default"
		case frontFemale = "front_female"
		case frontShiny = "front_shiny"
		case frontShinyFemale = "front_shiny_female"
	}
}

struct TypeElement: Codable {
	let type: Species
}
