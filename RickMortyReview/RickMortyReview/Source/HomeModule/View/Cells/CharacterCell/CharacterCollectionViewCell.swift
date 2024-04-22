//
//  CharacterCollectionViewCell.swift
//  RickMortyReview
//
//  Created by Fran Sarró on 22/4/24.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    private var cellID: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }

    private func setStyle() {
        starImageView.isHidden = true
    }

    func updateUI(data: CharacterVM) {
        cellID = data.id
        characterImageView.loadImageUsingCache(withUrl: data.image)
        nameLabel.text = data.name
        starImageView.isHidden = data.stars < 1
    }
    
    func getID() -> Int? {
        return cellID
    }
}
