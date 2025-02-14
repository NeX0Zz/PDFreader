//
//  DocumentListViewModel.swift
//  PDF reader
//
//  Created by Денис Николаев on 12.02.2025.

import SwiftUI
import PDFKit

class DocumentListViewModel: ObservableObject {
    @Published var documents: [PDFDocumentModel] = []
    @Published var selectedDocumentForMerge: PDFDocumentModel? = nil
    @Published var isSelectingForMerge = false
    @Published var isMergingDocuments = false
    @Published var errorMessage: String? = nil
    
    private let storage = PDFStorageService()

    func loadDocuments() {
        documents = storage.fetchDocuments()
    }

    func delete(document: PDFDocumentModel) {
        DispatchQueue.main.async {
            self.documents.removeAll { $0.id == document.id }
            do {
                if FileManager.default.fileExists(atPath: document.filePath) {
                    try FileManager.default.removeItem(atPath: document.filePath)
                    print("Файл успешно удален: \(document.filePath)")
                }
            } catch {
                print("Ошибка при удалении файла: \(error.localizedDescription)")
            }
            self.storage.deleteDocument(document)
        }
    }

    func share(document: PDFDocumentModel) {
        guard let fileURL = URL(string: document.filePath) else { return }
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController?.present(activityVC, animated: true)
        }
    }

    func startSelectingForMerge(document: PDFDocumentModel) {
        if selectedDocumentForMerge == document {
            selectedDocumentForMerge = nil
            isSelectingForMerge = false
            errorMessage = nil
            return
        }

        selectedDocumentForMerge = document
        isSelectingForMerge = true
        errorMessage = nil
    }

    func mergeWithSelectedDocument(document: PDFDocumentModel) {
        guard let firstDocument = selectedDocumentForMerge else {
            errorMessage = "Первый документ не выбран."
            return
        }

        if firstDocument == document {
            errorMessage = "Вы не можете объединить документ с самим собой."
            return
        }

        isMergingDocuments = true
        errorMessage = nil

        guard let mergedPDF = mergePDFs(firstDocument: firstDocument, secondDocument: document) else {
            errorMessage = "Ошибка при объединении документов."
            isMergingDocuments = false
            return
        }

        storage.saveMergedDocument(mergedPDF)

        DispatchQueue.main.async {
            self.loadDocuments()
        }

        isSelectingForMerge = false
        selectedDocumentForMerge = nil
        isMergingDocuments = false
    }

    private func mergePDFs(firstDocument: PDFDocumentModel, secondDocument: PDFDocumentModel) -> PDFDocument? {
        guard
            let firstPDF = PDFDocument(url: URL(fileURLWithPath: firstDocument.filePath)),
            let secondPDF = PDFDocument(url: URL(fileURLWithPath: secondDocument.filePath))
        else {
            print("Ошибка загрузки PDF документов.")
            return nil
        }

        let mergedPDF = PDFDocument()

        for index in 0..<firstPDF.pageCount {
            if let page = firstPDF.page(at: index) {
                mergedPDF.insert(page, at: mergedPDF.pageCount)
            }
        }

        for index in 0..<secondPDF.pageCount {
            if let page = secondPDF.page(at: index) {
                mergedPDF.insert(page, at: mergedPDF.pageCount)
            }
        }

        return mergedPDF
    }
}
