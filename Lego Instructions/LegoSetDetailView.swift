//
//  LegoSetDetailView.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import SwiftUI

struct LegoSetDetailView: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var set: LegoSet
    
    var onEdit: () -> Void

    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                
                ImageView(set.imagePath)
                
                VStack(alignment: .leading, spacing: 8) {
                    if let name = set.name,
                        let id = set.id {
                        Text(name)
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("\(id) | \(set.pieces) pieces")
                            .font(.title3)
                            .fontWeight(.light)
                        Spacer()
                        Spacer()
                        Image(set.theme ?? "Star Wars")
                            .interpolation(.high)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 40)
                    }
                }
                .padding(.vertical, 20)
                Spacer()
            }
            .padding()
            .background(.gray.opacity(0.1))
            let manualPaths = set.manualPaths
            if !manualPaths.isEmpty {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 12) {
                            ForEach(Array(manualPaths.enumerated()), id: \.element) { offset, filename in
                                if let fileURL = pdfFileURL(for: filename) {
                                    ManualBookButton(index: offset + 1, fileURL: fileURL)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
            }
            
        }
    }
    
    func openPDFInFullScreen(_ url: URL, _ title: String = "Book 1") {
        let hostingController = NSHostingController(rootView: PDFViewerWindow(url: url))
        let window = NSWindow(contentViewController: hostingController)
//        window.setFrame(NSScreen.main?.frame ?? .zero, display: true)
//        window.styleMask = [.fullSizeContentView, .titled, .resizable, .closable]
        window.makeKeyAndOrderFront(nil)
        window.toggleFullScreen(nil)
        window.title = title
    }
    
    private func pdfFileURL(for filename: String) -> URL? {
        guard let supportDir = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) else { return nil }

        return supportDir.appendingPathComponent("Manuals/\(filename)")
    }
}

struct ImageView: View {
    
    let imagePath: String?
    let imageSize, padding: CGFloat
    
    init(_ imagePath: String? = nil, _ imageSize: CGFloat = 160, _ padding: CGFloat = 20) {
        self.imagePath = imagePath
        self.imageSize = imageSize
        self.padding = padding
    }
    
    var body: some View {
        if let imagePath = self.imagePath,
           let imageURL = imageFileURL(for: imagePath),
           let image = NSImage(contentsOf: imageURL) {
            Image(nsImage: image)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: imageSize, maxHeight: imageSize)
                .padding(padding)
        }
    }
    
    private func imageFileURL(for imagePath: String) -> URL? {
        guard let supportDir = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) else { return nil }

        return supportDir.appendingPathComponent("Images/\(imagePath)")
    }
    
}
