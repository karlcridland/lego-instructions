//
//  ManualBookButton.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 10/07/2025.
//

import SwiftUI

struct ManualBookButton: View {
    let index: Int
    let fileURL: URL

    @State private var isHovered = false

    var body: some View {
        Button {
            NSWorkspace.shared.open(fileURL)
        } label: {
            withAnimation {
                VStack {
                    let size: CGFloat = 36
                    Image(systemName: "book.pages")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .font(.system(size: size, weight: .medium))
                        .padding(.bottom, 5)
                    Text("Book \(index)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(width: 80)
                }
                .padding(6)
                .foregroundStyle(isHovered ? Color(.systemBlue).opacity(0.7) : .black.opacity(0.7))
                .background(.gray.opacity(isHovered ? 0.1 : 0.01))
                .cornerRadius(8)
            }
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
            DispatchQueue.main.async {
                if hovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
}
