//
//  PokedexTableViewController.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class PokedexTableViewController: UITableViewController {

	let pokemonController = PokemonController()

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonController.pokemonArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)

        let pokemon = pokemonController.pokemonArray[indexPath.row]
		cell.textLabel?.text = pokemon.name.capitalized
		cell.detailTextLabel?.text = "\(pokemon.id)"

        return cell
    }

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		let pokemon = pokemonController.pokemonArray[indexPath.row]
		if editingStyle == .delete {
			pokemonController.delete(pokemon: pokemon)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SearchPokemonSegue" {
			guard let searchVC = segue.destination as? DetailViewController else { return }
			searchVC.pokemonController = pokemonController
		} else if segue.identifier == "PokemonDetailSegue" {
			if let detailVC = segue.destination as? DetailViewController,
				let indexPath = tableView.indexPathForSelectedRow {
				detailVC.pokemonController = pokemonController
				detailVC.pokemon = pokemonController.pokemonArray[indexPath.row]
			}
		}
    }
}
