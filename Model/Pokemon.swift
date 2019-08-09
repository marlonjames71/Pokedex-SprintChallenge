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
	let sprites: Sprites
}

struct Ability: Codable {
	let ability: Species
}

struct Species: Codable {
	let name: String
}

struct Sprites: Codable {
	let frontDefault: String
	let frontShiny: String

	enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
		case frontShiny = "front_shiny"
	}
}

struct TypeElement: Codable {
	let type: Species
}
