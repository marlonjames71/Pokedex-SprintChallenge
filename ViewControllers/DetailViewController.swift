//
//  DetailViewController.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	var pokemonController: PokemonController?
	var pokemon: Pokemon? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var idOutputLabel: UILabel!
	@IBOutlet weak var typesOutputLabel: UILabel!
	@IBOutlet weak var abilitiesOutputLabel: UILabel!
	@IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var typesLabel: UILabel!
	@IBOutlet weak var abilitiesLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()
		searchBar.delegate = self
		if pokemon == nil {
			isHidden(hidden: true)
		}
    }

    
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		guard let pokemonController = pokemonController,
			let pokemon = pokemon else { return }
		pokemonController.pokemonArray.append(pokemon)
		navigationController?.popToRootViewController(animated: true)
	}


	private func updateViews() {
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
					print(self.pokemon)
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
