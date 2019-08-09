//
//  DetailViewController.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	// MARK: - Properties & Outlets

	var pokemonController: PokemonController?
	var pokemon: Pokemon? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet weak var saveBarButton: UIBarButtonItem!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var idOutputLabel: UILabel!
	@IBOutlet weak var typesOutputLabel: UILabel!
	@IBOutlet weak var abilitiesOutputLabel: UILabel!
	@IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var typesLabel: UILabel!
	@IBOutlet weak var abilitiesLabel: UILabel!


	// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()
		searchBar.delegate = self
		if pokemon == nil {
			isHidden(hidden: true)
		}

		saveBarButton.setBackgroundImage(UIImage(named: "openPokeball"), for: .normal, barMetrics: .default)
		
    }


	// MARK: - IBActions

	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		guard let pokemonController = pokemonController,
			let pokemon = pokemon else { return }
		if pokemonController.pokemonArray.contains(pokemon) {
			let alert = UIAlertController(title: "You've already captured \(pokemon.name.capitalized)", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
		} else {
			pokemonController.addPokemon(pokemon: pokemon)
			navigationController?.popToRootViewController(animated: true)
		}
	}


	// MARK: - Helper Methods

	private func updateViews() {
		loadViewIfNeeded()
		if pokemon != nil {
			title = pokemon?.name.capitalized
		} else {
			title = "Pokemon Search"
		}

		guard let pokemon = pokemon else { return }
		nameLabel.text = pokemon.name.capitalized
		idOutputLabel.text = "\(pokemon.id)"

		var types: [String] = []
		for type in pokemon.types {
			types.append(type.type.name)
		}

		var abilities: [String] = []
		for ability in pokemon.abilities {
			abilities.append(ability.ability.name)
		}

		typesOutputLabel.text = types.joined(separator: ", ")
		abilitiesOutputLabel.text = abilities.joined(separator: ", ")

		pokemonController?.fetchSprites(from: pokemon.sprites.frontDefault, completion: { (result) in
			if let imageResult = try? result.get() {
				DispatchQueue.main.async {
					self.imageView.image = UIImage(data: imageResult)
				}
			}
		})
	}

	func isHidden(hidden: Bool) {
		nameLabel.isHidden = hidden
		idOutputLabel.isHidden = hidden
		typesOutputLabel.isHidden = hidden
		abilitiesOutputLabel.isHidden = hidden
		idLabel.isHidden = hidden
		typesLabel.isHidden = hidden
		abilitiesLabel.isHidden = hidden
	}
}

extension DetailViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchInput = searchBar.text,
			let pokeController = pokemonController else { return }

		pokeController.performPokemonSearch(searchTerm: searchInput) { (result) in
			
			if let pokemon = try? result.get() {
				DispatchQueue.main.async {
					self.pokemon = pokemon
					self.isHidden(hidden: false)
					self.updateViews()
				}

				pokeController.fetchSprites(from: pokemon.sprites.frontDefault, completion: { (result) in
					if let imageResult = try? result.get() {
						DispatchQueue.main.async {
							self.imageView.image = UIImage(data: imageResult)
							self.updateViews()
						}
					}
				})
			}
		}
	}
}
