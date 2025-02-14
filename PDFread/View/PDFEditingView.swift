//
//  PDFEditingView.swift
//  PDFread
//
//  Created by Денис Николаев on 13.02.2025.
//

import SwiftUI
import PDFKit

struct PDFEditingView: View {
    @StateObject private var viewModel: PDFEditingViewModel
    
    init(pdfURL: URL) {
        _viewModel = StateObject(wrappedValue: PDFEditingViewModel(pdfURL: pdfURL))
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

            if let pdfDocument = viewModel.pdfDocument {
                Picker("Выберите страницу для удаления", selection: $viewModel.selectedPageIndex) {
                    ForEach(0..<pdfDocument.pageCount, id: \.self) { index in
                        Text("Страница \(index + 1)").tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Сохранить PDF", action: viewModel.savePDF)
                    Button("Удалить страницу", action: viewModel.deletePage)
                    Button("Повернуть страницу", action: viewModel.rotatePage)
                    Button("Добавить текстовую страницу", action: viewModel.addTextPage)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}
