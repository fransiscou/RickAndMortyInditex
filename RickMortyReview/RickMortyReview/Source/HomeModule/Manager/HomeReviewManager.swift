//
//  HomeReviewManager.swift
//  RickMortyReview
//
//  Created by Fran Sarró on 22/4/24.
//

import Foundation

protocol HomeReviewProtocol {
    func saveRatingsBy(id: Int, stars: Int)
    func getRatingsBy(id: Int?) -> Int
}

class HomeReviewManager: HomeReviewProtocol {
    
    static var shared = HomeReviewManager()
    
    func saveRatingsBy(id: Int, stars: Int) {
        UserDefaults.standard.set(stars, forKey: String(describing: id))
    }
    
    func getRatingsBy(id: Int?) -> Int {
        guard let id = id else { return 0}
        return UserDefaults.standard.integer(forKey: String(describing: id))
    }
}
