//
//  PDFEditingViewModel.swift
//  PDFread
//
//  Created by Денис Николаев on 13.02.2025.
//

import SwiftUI
import PDFKit

class PDFEditingViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var selectedPageIndex: Int = 0
    private var pdfURL: URL
    
    init(pdfURL: URL) {
        self.pdfURL = pdfURL
        loadPDF()
    }
    
    private func loadPDF() {
        pdfDocument = PDFDocument(url: pdfURL)
    }
    
    func deletePage() {
        guard let pdfDocument = pdfDocument, pdfDocument.pageCount > 0 else {
            print("Ошибка: документ пуст или не загружен")
            return
        }
        
        let pageIndex = selectedPageIndex
        guard pageIndex >= 0, pageIndex < pdfDocument.pageCount else {
            print("Ошибка: недопустимый индекс страницы")
            return
        }
        
        print("Удаление страницы: \(pageIndex)")
        objectWillChange.send()
        pdfDocument.removePage(at: pageIndex)
        if let data = pdfDocument.dataRepresentation(), let newDocument = PDFDocument(data: data) {
            self.pdfDocument = newDocument
        }
    }
    
    func rotatePage() {
        guard let pdfDocument = pdfDocument,
              let page = pdfDocument.page(at: selectedPageIndex) else { return }
        
        page.rotation += 90
    }
    
    func addTextPage() {
        guard let pdfDocument = pdfDocument else { return }
        
        let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792)
        
        let text = "Новая страница с текстом"
        let renderer = UIGraphicsImageRenderer(size: pageBounds.size)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: .zero, size: pageBounds.size))
            
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.black
            ]
            
            let textSize = text.size(withAttributes: textAttributes)
            let textRect = CGRect(
                x: (pageBounds.width - textSize.width) / 2,
                y: (pageBounds.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            text.draw(in: textRect, withAttributes: textAttributes)
        }
        
        if let newPDFPage = PDFPage(image: image) {
            pdfDocument.insert(newPDFPage, at: pdfDocument.pageCount)
        }
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
