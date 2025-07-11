//
//  PDFDropArea.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct PDFInstruction: Identifiable, Equatable {
    let id = UUID()
    let url: URL

    var filename: String {
        url.lastPathComponent
    }
}

struct PDFDropArea: View {
    @Binding var pdfs: [PDFInstruction]
    @State private var isTargeted: Bool = false
    @State private var draggingItem: PDFInstruction?

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 12) {
                    ForEach(pdfs) { pdf in
                        VStack {
                            Image(systemName: "book.pages")
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .font(.system(size: 30, weight: .semibold))
                            Text(pdf.filename)
                                .font(.caption)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .frame(width: 80)
                        }
                        .opacity(draggingItem == pdf ? 0.3 : 1) // fade while dragging
                        .padding(6)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8)
                        .onDrag {
                            self.draggingItem = pdf
                            return NSItemProvider(object: pdf.url as NSURL)
                        }
                        .onDrop(of: [.fileURL], delegate: PDFDropDelegate(
                            item: pdf,
                            items: $pdfs,
                            draggingItem: $draggingItem
                        ))
                    }
                    .onMove(perform: move)
                }
            }
        }
        .padding(16)
        .frame(minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                    isTargeted ? Color.accentColor : Color.gray.opacity(0.4),
                    style: StrokeStyle(lineWidth: 2, dash: [6])
                )
                .animation(.easeInOut(duration: 0.2), value: isTargeted)
        )
        .onDrop(of: [.fileURL], isTargeted: $isTargeted, perform: handleDrop)
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (item, _) in
                guard let data = item as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil),
                      url.pathExtension.lowercased() == "pdf" else { return }

                DispatchQueue.main.async {
                    guard let saveURL = savePDFToAppSupport(url: url) else { return }
                    if !pdfs.contains(where: { $0.url == saveURL }) {
                        pdfs.append(PDFInstruction(url: saveURL))
                    }
                }
            }
        }
        return true
    }

    private func savePDFToAppSupport(url: URL) -> URL? {
        guard let appSupport = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("Manuals", isDirectory: true) else { return nil }

        try? FileManager.default.createDirectory(at: appSupport, withIntermediateDirectories: true)

        let destURL = appSupport.appendingPathComponent(url.lastPathComponent)
        if !FileManager.default.fileExists(atPath: destURL.path) {
            try? FileManager.default.copyItem(at: url, to: destURL)
        }

        return destURL
    }

    private func move(from source: IndexSet, to destination: Int) {
        pdfs.move(fromOffsets: source, toOffset: destination)
    }
}

struct PDFDropDelegate: DropDelegate {
    let item: PDFInstruction
    @Binding var items: [PDFInstruction]
    @Binding var draggingItem: PDFInstruction?

    func dropEntered(info: DropInfo) {
        guard let dragging = draggingItem,
              let from = items.firstIndex(of: dragging),
              let to = items.firstIndex(of: item),
              from != to else { return }

        withAnimation {
            items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggingItem = nil
        return true
    }
}
