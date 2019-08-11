//
//  PokemonCollectionViewCell.swift
//  Pokedex-SprintChallenge
//
//  Created by Marlon Raskin on 8/9/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var viewForShadow: UIView!
	@IBOutlet weak var viewForImage: UIView!
	@IBOutlet weak var imageView: UIImageView!

	let gradient = CAGradientLayer()

	override func awakeFromNib() {
		super.awakeFromNib()
		setUI()
	}



	func setUI() {
		viewForShadow.layer.cornerRadius = 12
		viewForShadow.layer.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 0.9771736005)
		viewForShadow.layer.shadowRadius = 12
		viewForShadow.layer.shadowOpacity = 0.4
		viewForImage.layer.cornerRadius = 12
		viewForImage.layer.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 0.9771736005)
		viewForImage.layer.shadowRadius = 12
		viewForImage.layer.shadowOpacity = 0.4
		viewForImage.layer.masksToBounds = true
		gradient.frame = viewForImage.bounds
		gradient.colors = [UIColor(red: 1.00, green: 0.11, blue: 0.33, alpha: 0.95).cgColor,
						   UIColor(red: 1.00, green: 0.11, blue: 0.25, alpha: 0.65).cgColor]
		viewForImage.layer.insertSublayer(gradient, at: 0)
	}
}
