//
//  SequenceExtensions.swift
//  Wage
//
//  Created by Patrick Rugebregt on 29/09/2022.
//

import Foundation

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
}
