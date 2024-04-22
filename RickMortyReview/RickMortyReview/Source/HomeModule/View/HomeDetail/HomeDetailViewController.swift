//
//  HomeDetailViewController.swift
//  RickAndMorty
//
//  Created by Fran Sarró on 19/4/24.
//

import UIKit

protocol HomeDetailDelegate: AnyObject {
    func didDismiss()
}

protocol HomeDetailPresenterDelegate: AnyObject {
    func setupView()
    func sendReview(stars: Int)
}

protocol HomeDetailNavigatorDelegate: AnyObject {
    func navigateToBack()
}

class HomeDetailViewController: UIViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameCharacterLabel: UILabel!
    @IBOutlet weak var aliveSpecieLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var lastKnownLocationTitleLabel: UILabel!
    @IBOutlet weak var lastKownLocationDescriptionLabel: UILabel!
    
    @IBOutlet weak var firstSeenInTitleLabel: UILabel!
    @IBOutlet weak var firstSeenInDescriptionLabel: UILabel!
    
    @IBOutlet weak var firstStarButton: UIButton!
    
    @IBOutlet weak var secondStarButton: UIButton!
    @IBOutlet weak var thirdStarButton: UIButton!
    
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fifthStarButton: UIButton!
    
    weak var delegate: HomeDetailDelegate?
    var presenter: HomeDetailPresenterDelegate?
    var dataStore: HomeDetailDataStore?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPresenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
        setUpStarsTargets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didDismiss()
    }
    
    func setupPresenter() {
        let presenter = HomeDetailPresenter()
        presenter.view = self
        self.dataStore = presenter
        self.presenter = presenter
    }
    
    @objc func onTap(_ sender: UIButton?) {
        guard let btn = sender, let identifier = Int(btn.accessibilityIdentifier ?? "0") else { return }
        
        updateStarsUI(stars: identifier)
        presenter?.sendReview(stars: identifier)
    }
    
    func setUpStarsTargets() {
        let starButtons = [firstStarButton, secondStarButton, thirdStarButton, fourStarButton, fifthStarButton]
        
        for (index, button) in starButtons.enumerated() {
            button?.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
            button?.accessibilityIdentifier = "\(index + 1)"
        }
    }
    
    private func updateStarsUI(stars: Int) {
        let starSelected: UIImage? = UIImage(systemName: HomeConstants.starFill)?.withTintColor(.systemYellow).withRenderingMode(.alwaysOriginal)
        let starUnSelected: UIImage? = UIImage(systemName: HomeConstants.star)?.withTintColor(.gray).withRenderingMode(.alwaysOriginal)
        
        for (index, button) in [firstStarButton, secondStarButton, thirdStarButton, fourStarButton, fifthStarButton].enumerated() {
            button?.setImage(stars >= index + 1 ? starSelected : starUnSelected, for: .normal)
        }
    }
}

extension HomeDetailViewController: HomeDetailViewDelegate {
    
    func setStars(numStars: Int) {
        self.updateStarsUI(stars: numStars)
    }
    
    func setImage(image: String) {
        DispatchQueue.main.async { [weak self] in
            self?.characterImageView.loadImageUsingCache(withUrl: image)
        }
    }
    
    func setCharacterName(name: String) {
        nameCharacterLabel.text = name
        self.title = name
    }
    
    
    func setStatusAndSpecie(status: String, specie: String) {
        self.aliveSpecieLabel.text = "\(status) - \(specie)"
        guard let statusEnum = AliveStatus(rawValue: status) else {
            return
        }
        
        switch statusEnum {
        case .alive:
            self.statusImageView.setImageColor(color: UIColor.systemGreen)
        case .dead:
            self.statusImageView.setImageColor(color: UIColor.systemRed)
        case .unknown:
            self.statusImageView.setImageColor(color: UIColor.systemGray)
        }
    }
    
    func setLocation(location: String) {
        self.lastKnownLocationTitleLabel.text = HomeConstants.lastKownLocation
        self.lastKownLocationDescriptionLabel.text = location
    }
    
    func setOrigin(origin: String) {
        firstSeenInTitleLabel.text = HomeConstants.firstSeenIn
        firstSeenInDescriptionLabel.text = origin
    }
    
}

extension HomeDetailViewController: HomeDetailNavigatorDelegate {
    func navigateToBack() {
        delegate?.didDismiss()
        dismiss(animated: true)
    }
}
