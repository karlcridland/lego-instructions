//
//  SetHeaderButton.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 10/07/2025.
//

import SwiftUI

struct SetHeaderButton: View {
    
    @State var text: String
    
    let systemName: String
    let color: NSColor
    var action: () -> Void
    
    @State private var isHovered = false
    @Namespace private var animation

    var body: some View {
        ZStack(alignment: .trailing) {
            Button {
                action()
            } label: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    Image(systemName: systemName)
                        .padding(6)
                        .foregroundStyle(isHovered ? Color(color) : Color(.labelColor).opacity(0.7))
                        .background(.gray.opacity(isHovered ? 0.1 : 0.01))
                        .scaledToFit()
                        .font(.system(size: 18, weight: .semibold))
                        .cornerRadius(6)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
                DispatchQueue.main.async {
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }

            if isHovered {
                Text(text)
                    .font(.caption)
                    .padding(6)
                    .background(Color(color))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .offset(x: -40)
                    .zIndex(1)
            }
        }
    }
}
