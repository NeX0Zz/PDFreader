//
//  PDFReaderViewModel.swift
//  PDFread
//
//  Created by Денис Николаев on 13.02.2025.
//

import SwiftUI
import PDFKit

class PDFReaderViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    var pdfURL: URL
    
    init(pdfURL: URL) {
        self.pdfURL = pdfURL
        loadPDF()
    }
    
    func loadPDF() {
        if FileManager.default.fileExists(atPath: pdfURL.path),
           let document = PDFDocument(url: pdfURL) {
            self.pdfDocument = document
        } else {
            print("Ошибка: не удалось загрузить PDF по пути: \(pdfURL.path)")
        }
    }
    
    func deletePage() {
        guard let pdfDocument = pdfDocument, pdfDocument.pageCount > 0 else {
            print("Ошибка: документ пуст или не загружен")
            return
        }
        
        let pageIndex = 0
        print("Удаление страницы: \(pageIndex)")
        
        objectWillChange.send()
        pdfDocument.removePage(at: pageIndex)
        if let data = pdfDocument.dataRepresentation(), let newDocument = PDFDocument(data: data) {
            self.pdfDocument = newDocument
        }
    }
    
    func sharePDF(from viewController: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        viewController.present(activityVC, animated: true, completion: nil)
    }
    
    func savePDF() {
        guard let pdfDocument = pdfDocument else { return }
        
        if let data = pdfDocument.dataRepresentation() {
            do {
                try data.write(to: pdfURL)
                print("PDF успешно сохранен по пути: \(pdfURL.path)")
            } catch {
                print("Ошибка сохранения PDF: \(error.localizedDescription)")
            }
        } else {
            print("Ошибка: невозможно получить данные PDF")
        }
    }
}
