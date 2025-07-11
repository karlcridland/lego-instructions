//
//  ImageDropView.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import SwiftUI

struct ImageDropView: View {
    @Binding var imagePath: String?
    let setID: String

    @State private var isDraggingOver = false
    @State private var imagePreview: NSImage?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(isDraggingOver ? Color.accentColor.opacity(0.3) : Color.gray.opacity(0.1))
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .overlay(
                    Group {
                        if let imagePreview {
                            Image(nsImage: imagePreview)
                                .resizable()
                                .scaledToFit()
                        } else {
                            VStack {
                                Image(systemName: "photo")
                            }
                        }
                    }
                    .padding()
                )
                .onDrop(of: [.fileURL, .image], isTargeted: $isDraggingOver) { providers in
                    loadImage(from: providers)
                    return true
                }
                .onTapGesture {
                    let panel = NSOpenPanel()
                    panel.allowedContentTypes = [.png, .jpeg, .webP, .heic]
                    panel.allowsMultipleSelection = false
                    if panel.runModal() == .OK {
                        if let url = panel.url {
                            saveImageToDisk(from: url)
                        }
                    }
                }
        }
        .onAppear {
            loadImagePreview()
        }
    }

    // MARK: - Save image to disk

    func saveImageToDisk(from url: URL) {
        guard let data = try? Data(contentsOf: url),
              let appSupportURL = try? FileManager.default.url(
                  for: .applicationSupportDirectory,
                  in: .userDomainMask,
                  appropriateFor: nil,
                  create: true
              ).appendingPathComponent("Images", isDirectory: true) else {
            return
        }

        try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)

        let filename = "\(setID).png"
        let fileURL = appSupportURL.appendingPathComponent(filename)

        if let image = NSImage(data: data),
           let tiff = image.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiff),
           let pngData = bitmap.representation(using: .png, properties: [:]) {
            try? pngData.write(to: fileURL)
            self.imagePath = filename
            self.imagePreview = NSImage(data: pngData)
        }
    }

    // MARK: - Load preview if existing

    func loadImagePreview() {
        guard let imagePath,
              let appSupportURL = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        else { return }

        let imageURL = appSupportURL.appendingPathComponent("Images/\(imagePath)")
        if let image = NSImage(contentsOf: imageURL) {
            self.imagePreview = image
        }
    }

    // MARK: - From drop

    func loadImage(from providers: [NSItemProvider]) {
        guard let provider = providers.first else { return }
        provider.loadDataRepresentation(forTypeIdentifier: "public.image") { data, _ in
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
            if let data = data {
                try? data.write(to: tempURL)
                DispatchQueue.main.async {
                    saveImageToDisk(from: tempURL)
                }
            }
        }
    }
}
