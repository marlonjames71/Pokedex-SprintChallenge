//
//  PokemonController.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case noToken
	case badURL
	case noData
	case noDecode
	case otherError(Error)
	case badStatusCode
}

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delet = "DELETE"
}

class PokemonController {

	// MARK: - Properties

	var pokemonArray: [Pokemon] = []
	let baseURL = URL(string: "https://pokeapi.co/api/v2")!

	// MARK: - Init

	init() {
		loadFromPersistentStore()
	}


	// MARK: - API functions

	func performPokemonSearch(searchTerm: String, completion: @escaping(Result<Pokemon, NetworkError>) -> Void) {

		let pokemonURL = baseURL.appendingPathComponent("pokemon")
								.appendingPathComponent(searchTerm.lowercased())

		var request = URLRequest(url: pokemonURL)
		request.httpMethod = HTTPMethod.get.rawValue

		URLSession.shared.dataTask(with: request) { (data, _, error) in

			if let error = error {
				NSLog("Error fetching pokemon: \(error)")
				completion(.failure(.otherError(error)))
				return
			}

			guard let data = data else {
				NSLog("No data returned with fetching: \(searchTerm)")
				completion(.failure(.noData))
				return
			}

			do {
				let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
				completion(.success(pokemon))
			} catch {
				NSLog("Error decoding Pokemon object: \(error)")
				completion(.failure(.noDecode))
			}
		}.resume()
	}


	func fetchSprites(from imageURL: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {

		let imageURL = URL(string: imageURL)!

		var request = URLRequest(url: imageURL)
		request.httpMethod = HTTPMethod.get.rawValue

		URLSession.shared.dataTask(with: request) { (imageData, _, error) in

			if let error = error {
				completion(.failure(.otherError(error)))
				NSLog("Error fetching image: \(error)")
				return
			}

			guard let data = imageData else {
				completion(.failure(.noData))
				NSLog("No data provided for image: \(imageURL)")
				return
			}
			completion(.success(data))
		}.resume()
	}


	// MARK: - Pokemon Functions

	func addPokemon(pokemon: Pokemon) {
		pokemonArray.append(pokemon)
		saveToPersistentStore()
	}

	func delete(pokemon: Pokemon) {
		guard let index = pokemonArray.firstIndex(of: pokemon) else { return }
		pokemonArray.remove(at: index)
		saveToPersistentStore()
	}


	// MARK: - Persistent Store Functions

	func saveToPersistentStore() {
		guard let url = pokemonListURL else { return }

		do {
			let encoder = PropertyListEncoder()
			let pokemonData = try encoder.encode(pokemonArray)
			try pokemonData.write(to: url)
		} catch {
			print("Error encoding Pokemon List: \(error)")
		}
	}

	func loadFromPersistentStore() {
		do {
			guard let url = pokemonListURL else { return }
			let pokemonData = try Data(contentsOf: url)
			let decoder = PropertyListDecoder()
			let decodePokemon = try decoder.decode([Pokemon].self, from: pokemonData)
			pokemonArray = decodePokemon
		} catch {
			print("Error decoding Pokemon data: \(error)")
		}
	}

	private var pokemonListURL: URL? {
		let fm = FileManager.default
		guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		return dir.appendingPathComponent("PokemonList.plist")
	}
}
