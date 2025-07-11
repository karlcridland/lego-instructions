//
//  ContentView.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \LegoSet.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<LegoSet>

    @State private var selectedSet: LegoSet?
    @State private var editingSet: LegoSet?
    @State private var showEditor = false

    var body: some View {
        NavigationSplitView {
            VStack {
                List(selection: $selectedSet) {
                    ForEach(items) { legoSet in
                        HStack (spacing: 10) {
                            ImageView(legoSet.imagePath, 32, 0)
                            VStack(alignment: .leading) {
                                if let name = legoSet.name,
                                   let id = legoSet.id {
                                    Text(name)
                                        .font(.headline)
                                    Text([id, legoSet.theme ?? "Star Wars"].joined(separator: " | "))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(5)
                        .contentShape(Rectangle())
                        .tag(legoSet)
                        .contextMenu {
                            Button("Edit set") {
                                editingSet = legoSet
                                showEditor = true
                                
                            }
                            Button("Delete set", role: .destructive) {
                                if (selectedSet == legoSet) {
                                    selectedSet = nil
                                }
                                context.delete(legoSet)
                                try? context.save()
                            }
                        }
                        .task {
                            if (selectedSet == nil) {
                                selectedSet = legoSet
                            }
                        }
                    }
                }
                .navigationTitle("LEGO Instructions")
                .navigationSplitViewColumnWidth(min: 200, ideal: 300)
                .toolbar {
                    Button(action: {
                        editingSet = nil
                        showEditor = true
                    }) {
                        Label("Add Set", systemImage: "plus")
                    }
                }
            }
            .frame(minWidth: 240) // ✅ Ensure sidebar stays wide enough
        } detail: {
            if let selectedSet {
                LegoSetDetailView(set: selectedSet) {
                    editingSet = selectedSet
                    showEditor = true
                }
            } else {
                Text("Select a set")
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showEditor) {
            LegoSetEditor(
                existingSet: $editingSet,
                onSave: { _ in }
            )
        }
    }
}
