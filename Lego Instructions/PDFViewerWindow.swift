//
//  PDFViewerWindow.swift
//  Lego Instructions
//
//  Created by Karl Cridland on 10/07/2025.
//


import SwiftUI
import PDFKit

struct PDFViewerWindow: View {
    let url: URL

    var body: some View {
        PDFKitRepresentedView(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

struct PDFKitRepresentedView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: Context) {}
}