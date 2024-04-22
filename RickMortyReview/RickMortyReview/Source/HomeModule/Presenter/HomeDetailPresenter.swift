//
//  HomeDetailPresenter.swift
//  RickMortyReview
//
//  Created by Fran Sarró on 22/4/24.
//

import Foundation

enum AliveStatus : String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

protocol HomeDetailViewDelegate: AnyObject {
    func setStars(numStars: Int)
    func setImage(image: String)
    func setCharacterName(name: String)
    func setStatusAndSpecie(status: String, specie: String)
    func setLocation(location: String)
    func setOrigin(origin: String)
}

protocol HomeDetailDataStore {
    var character: Character? { get set }
}


class HomeDetailPresenter: HomeDetailPresenterDelegate, HomeDetailDataStore {
    
    weak var view: (HomeDetailViewDelegate & HomeDetailNavigatorDelegate)?
    
    var repository: HomeServicesProtocol = HomeServices()
    var character: Character?
    var dataStore: HomeDetailDataStore?

    func setupView() {
        setDataCharacter()
    }

    
    private func setDataCharacter() {
        guard let character = character else { return }
        view?.setStars(numStars: HomeReviewManager.shared.getRatingsBy(id: character.id ?? nil))
        view?.setCharacterName(name: character.name ?? "")
        view?.setImage(image: character.image ?? "")
        view?.setStatusAndSpecie(status: character.status ?? "", specie: character.species ?? "")
        view?.setOrigin(origin: character.origin?.name ?? "")
        view?.setLocation(location: character.location?.name ?? "")
    }
    
    func sendReview(stars: Int) {
        guard let character = character, let id = character.id else { return }
        
        if HomeReviewManager.shared.getRatingsBy(id: id) == stars {
            HomeReviewManager.shared.saveRatingsBy(id: id, stars: 0)
            view?.setStars(numStars: 0)
        } else {
            HomeReviewManager.shared.saveRatingsBy(id: id, stars: stars)
        }
    }
    
}
