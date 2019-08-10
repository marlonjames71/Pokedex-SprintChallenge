//
//  PokemonCollectionViewCell.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var viewForImage: UIView!
	@IBOutlet weak var imageView: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		setUI()
	}



	func setUI() {
		viewForImage.layer.cornerRadius = 12
		viewForImage.layer.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 0.9771736005)
		viewForImage.layer.shadowRadius = 12
		viewForImage.layer.shadowOpacity = 0.4
	}
}
