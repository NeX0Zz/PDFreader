//
//  PDFEditorView.swift
//  PDFread
//
//  Created by Денис Николаев on 12.02.2025.
//

import SwiftUI
import PDFKit

struct PDFEditorView: View {
    @State private var selectedPDF: URL?
    @State private var isDocumentPickerPresented = false

    var body: some View {
        VStack {
            if let pdfURL = selectedPDF {
                NavigationLink(destination: PDFEditingView(pdfURL: pdfURL)) {
                    Text("Редактировать PDF")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal, 40)
                }
            } else {
                Text("Выберите PDF-файл для редактирования")
                    .foregroundColor(.gray)

                Button(action: {
                    isDocumentPickerPresented = true
                }) {
                    Text("Выбрать PDF")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)
            }
        }
        .sheet(isPresented: $isDocumentPickerPresented) {
            DocumentPicker(selectedPDF: $selectedPDF)
        }
        .onChange(of: selectedPDF) { newValue in
            if newValue != nil {
                isDocumentPickerPresented = false
            }
        }
        .navigationTitle("Редактор PDF")
    }
}
