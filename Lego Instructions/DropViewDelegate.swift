//
//  DropViewDelegate.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 09/07/2025.
//

import SwiftUI

struct DropViewDelegate: DropDelegate {
    let item: PDFInstruction
    @Binding var current: PDFInstruction?
    @Binding var pdfs: [PDFInstruction]

    func dropEntered(info: DropInfo) {
        guard let current = current, current != item,
              let fromIndex = pdfs.firstIndex(of: current),
              let toIndex = pdfs.firstIndex(of: item)
        else { return }

        withAnimation {
            pdfs.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}
