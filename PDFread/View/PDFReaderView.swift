//
//  PDFReaderView.swift
//  PDFread
//
//  Created by Денис Николаев on 13.02.2025.
//

import SwiftUI
import PDFKit

struct PDFReaderView: View {
    @StateObject private var viewModel: PDFReaderViewModel

    init(pdfURL: URL) {
        _viewModel = StateObject(wrappedValue: PDFReaderViewModel(pdfURL: pdfURL))
    }

    var body: some View {
        VStack {
            if let pdfDocument = viewModel.pdfDocument {
                PDFKitView(document: pdfDocument)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Ошибка загрузки PDF")
                    .foregroundColor(.red)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Поделиться", action: sharePDF)
                    Button("Удалить текущую страницу", action: viewModel.deletePage)
                    Button("Сохранить PDF", action: viewModel.savePDF)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .onAppear {
            viewModel.loadPDF()
            print("Загрузка PDF из: \(viewModel.pdfURL.path)")
        }
    }
    
    

    private func sharePDF() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            viewModel.sharePDF(from: rootViewController)
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}
