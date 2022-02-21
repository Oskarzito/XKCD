//
//  Strings.swift
//  Comic
//
//  Created by Oskar Emilsson on 2022-02-21.
//

import Foundation

enum ComicStrings: String {
    case generalShare = "Share"
    case generalClose = "Close"
    case generalNext = "Next"
    case generalExplanation = "Explanation?"
    case generalCancel = "Cancel"
    case generalSearch = "Search"
}

func String(_ value: ComicStrings) -> String {
    return value.rawValue
}
