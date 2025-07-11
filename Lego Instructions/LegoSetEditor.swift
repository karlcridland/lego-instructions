//
//  LegoSetEditor.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import SwiftUI

struct LegoSetEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Binding var existingSet: LegoSet?

    @State private var id: String = ""
    @State private var name: String = ""
    @State private var pieces: Int16 = 0
    @State private var pdfs: [PDFInstruction] = []
    @State private var imagePath: String? = nil
    @State private var theme: Theme = .StarWars

    var onSave: (LegoSet) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(existingSet == nil ? "Create LEGO Set" : "Edit LEGO Set")
                .font(.title)
                .padding(.bottom)

            Form {
                VStack (alignment: .leading) {
                    HStack {
                        VStack {
                            TextField("Name", text: $name)
                            TextField("Set ID", text: $id)
                            TextField("Pieces", value: $pieces, format: .number)
                            HStack {
                                Button("previous", systemImage: "chevron.left") {
                                    theme = theme.previous()
                                }
                                Spacer()
                                Text(theme.rawValue)
                                Spacer()
                                Button("next", systemImage: "chevron.right") {
                                    theme = theme.next()
                                }
                            }
                        }
                        ImageDropView(imagePath: $imagePath, setID: id)
                    }
                }
            }
            Text("Instruction manuals")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            PDFDropArea(pdfs: $pdfs)
                .frame(height: 80)
                .padding(.bottom)

            HStack {
                Spacer()
                Button("Save") {
                    let setToSave = existingSet ?? LegoSet(context: context)

                    setToSave.id = id
                    setToSave.name = name
                    setToSave.pieces = pieces
                    setToSave.imagePath = imagePath
                    setToSave.theme = theme.rawValue
                    let manuals = pdfs.map { $0.url.lastPathComponent }
                    setToSave.manualPaths = manuals

                    do {
                        try context.save()
                        onSave(setToSave)
                        dismiss()
                    } catch {
                        print("Failed to save set: \(error)")
                    }
                }
                .keyboardShortcut(.defaultAction)

                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
            }
            .padding(.top)
        }
        .padding()
        .frame(width: 400)
        .onAppear {
            if let set = existingSet,
               let id = set.id,
               let name = set.name {
                self.id = id
                self.name = name
                self.pieces = set.pieces
                self.imagePath = set.imagePath
                self.theme = Theme(rawValue: set.theme ?? "Star Wars") ?? .StarWars
                if let baseURL = try? FileManager.default.url(
                    for: .applicationSupportDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                ).appendingPathComponent("Manuals", isDirectory: true) {
                    self.pdfs = set.manualPaths.compactMap { filename in
                        let fileURL = baseURL.appendingPathComponent(filename)
                        return FileManager.default.fileExists(atPath: fileURL.path) ? PDFInstruction(url: fileURL) : nil
                    }
                }
            }
        }
    }
}
