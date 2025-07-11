//
//  FileManager.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import Foundation

extension FileManager {
    static var legoImageDirectory: URL {
        let folder = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appendingPathComponent("LegoInstructions/Images", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }
}
