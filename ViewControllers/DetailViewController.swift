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

	var pokemonImages: [UIImage] = []
	var pokemon: Pokemon? {
		didSet {
			pokemonImages.removeAll(keepingCapacity: true)
			updateViews()
		}
	}

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var saveBarButton: UIBarButtonItem!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var nameLabel: UILabel!
//	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var idOutputLabel: UILabel!
	@IBOutlet weak var typesOutputLabel: UILabel!
	@IBOutlet weak var abilitiesOutputLabel: UILabel!
	@IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var typesLabel: UILabel!
	@IBOutlet weak var abilitiesLabel: UILabel!


	// MARK: - Lifecycle

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.reloadData()
		searchBar.delegate = self
		if pokemon == nil {
			searchBar.becomeFirstResponder()
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

		title = pokemon?.name.capitalized ?? "Pokemon Search"

		isHidden(hidden: pokemon == nil)

		if pokemon == nil {
			searchBar.isHidden = false
		} else {
			searchBar.isHidden = true
		}

		guard let pokemon = pokemon else { return }

		nameLabel.text = pokemon.name.capitalized
		idOutputLabel.text = "\(pokemon.id)"

		let types: [String] = pokemon.types.map { $0.type.name }
		let abilities: [String] = pokemon.abilities.map { $0.ability.name }

		typesOutputLabel.text = types.joined(separator: ", ")
		abilitiesOutputLabel.text = abilities.joined(separator: ", ")

		for sprite in pokemon.sprites {
			pokemonController?.fetchSprite(from: "\(sprite.value)", completion: { (result) in
				if let imageResult = try? result.get(),
					let image = UIImage(data: imageResult) {
					self.pokemonImages.append(image)
				}
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
			})
		}
	}

	func isHidden(hidden: Bool) {
		[nameLabel, idOutputLabel, typesOutputLabel,
		 abilitiesLabel, idLabel, typesLabel,
		 abilitiesOutputLabel].forEach { $0?.isHidden = hidden }
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
		searchBar.endEditing(true)
	}
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pokemonImages.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? PokemonCollectionViewCell else { return UICollectionViewCell() }

		cell.imageView.image = pokemonImages[indexPath.row]

		return cell
	}
}
