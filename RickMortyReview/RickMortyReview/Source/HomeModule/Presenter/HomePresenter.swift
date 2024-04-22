//
//  HomePresenter.swift
//  RickMortyReview
//
//  Created by Fran Sarró on 22/4/24.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
    func setupView()
    func reloadTable()
    func showAlertError()
    func updateSegmentedByGenderOptions()
}

class HomePresenter: HomePresenterDelegate {
    
    weak var view: (HomeViewDelegate & HomeNavigatorDelegate)?
    
    var homeService: HomeServicesProtocol = HomeServices()
    private var characters: [Character?] = []
    private var filteredCharacters: [Character?] = []
    
    func setupView() {
        view?.setupView()
        getData()
        
    }
    
    private func getData() {
        homeService.getCharacters { [weak self] result in
            switch result {
            case .success(let data):
                self?.characters = data.results
                self?.filteredCharacters = data.results
                self?.reloadTableAndViewOptions()
            case .failure(let error):
                print("Error fetching data: \(error)")
                self?.view?.showAlertError()
            }
        }
    }
    
    private func reloadTableAndViewOptions() {
        view?.reloadTable()
        view?.updateSegmentedByGenderOptions()
    }
    
    // MARK: Filter Options

    func filterByGender(gender: String) {
        filteredCharacters.removeAll()
        
        if gender.isEmpty || gender == "All" {
            filteredCharacters = characters
        } else {
            filteredCharacters = characters.filter { $0?.gender?.lowercased() == gender.lowercased() }
        }
        
        view?.reloadTable()
    }
    
    func getGenderOptions() -> [String] {
        var genderTypes = [String]()
        for character in self.characters {
            if let gender = character?.gender, !genderTypes.contains(gender) {
                genderTypes.append(gender.capitalized)
            }
        }

        return genderTypes
    }
    
    // MARK: CollectionView
    
    func getNumberOfCells() -> Int {
        return filteredCharacters.count
    }
    
    func getCellBy(row: Int) -> CharacterVM? {
        guard let character = filteredCharacters[row], let characterImage = character.image,
              let characterName = character.name, let id = character.id else { return nil }
        return CharacterVM(id: id, image: characterImage, name: characterName, stars: HomeReviewManager.shared.getRatingsBy(id: id))
    }
    
    func didSelectedCell(id: Int?) {
        guard let id = id, let character = characters.filter({ $0?.id == id }).first, let character = character else { return }
        view?.navigateToDetails(character: character)
    }
}

