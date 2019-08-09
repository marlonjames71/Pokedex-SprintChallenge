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
	

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
	}


	private func updateViews() {
		guard let pokemon = pokemon else { return }
		nameLabel.text = pokemon.name
		idOutputLabel.text = "\(pokemon.id)"
		let types = "\([pokemon.types])"
//		typesOutputLabel.text =
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
				}
			}
		}
	}
}
