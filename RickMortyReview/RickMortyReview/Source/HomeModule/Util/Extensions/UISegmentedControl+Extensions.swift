//
//  UISegmentedControl+Extensions.swift
//  RickMortyReview
//
//  Created by Fran Sarró on 22/4/24.
//

import UIKit

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
