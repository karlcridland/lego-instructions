//
//  Theme.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 10/07/2025.
//

enum Theme: String, CaseIterable {
    
    case Disney = "Disney"
    case HarryPotter = "Harry Potter"
    case Icons = "Icons"
    case JurassicPark = "Jurassic Park"
    case LordOfTheRings = "Lord of the Rings"
    case Marvel = "Marvel"
    case StarWars = "Star Wars"
    
    func next() -> Theme {
        let i = Theme.allCases.firstIndex(of: self)!
        print(i, Theme.allCases.count)
        if (i + 1 < Theme.allCases.count) {
            return Theme.allCases[i + 1]
        }
        return .Disney
    }
    
    func previous() -> Theme {
        let i = Theme.allCases.firstIndex(of: self)!
        if (i > 0) {
            return Theme.allCases[i - 1]
        }
        return .StarWars
    }
    
}
