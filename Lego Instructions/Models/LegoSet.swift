//
//  LegoSet.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import Foundation
import CoreData

extension LegoSet {

    var manualPaths: [String] {
        get { (manualPathsRaw as? [String]) ?? [] }
        set { manualPathsRaw = newValue as NSObject }
    }
    
}
