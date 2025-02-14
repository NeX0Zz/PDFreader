//
//  PDFStorageService.swift
//  PDF reader
//
//  Created by Денис Николаев on 12.02.2025.
//

import RealmSwift
import PDFKit

class PDFStorageService {
    private let realm = try! Realm()
    
    func saveDocument(title: String, pdfURL: URL) {
        guard let thumbnail = generateThumbnail(for: pdfURL) else { return }
        let document = PDFDocumentModel(title: title, filePath: pdfURL.path, thumbnail: thumbnail)
        
        try? realm.write {
            realm.add(document)
        }
    }
    
    func saveMergedDocument(_ mergedPDF: PDFDocument) {
        let mergedFileURL = getUniqueFileURL()
        mergedPDF.write(to: mergedFileURL)
        
        let newDocument = PDFDocumentModel(title: "Объединённый документ", filePath: mergedFileURL.path, thumbnail: generateThumbnail(for: mergedFileURL) ?? Data())
        try? realm.write {
            realm.add(newDocument)
        }
    }
    
    func fetchDocuments() -> [PDFDocumentModel] {
        return Array(realm.objects(PDFDocumentModel.self).sorted(byKeyPath: "createdAt", ascending: false))
    }

    func deleteDocument(_ document: PDFDocumentModel) {
        do {
            if FileManager.default.fileExists(atPath: document.filePath) {
                try FileManager.default.removeItem(atPath: document.filePath)
                print("Удалён файл: \(document.filePath)")
            }
            
            try realm.write {
                realm.delete(document)
            }
        } catch {
            print("Ошибка при удалении документа: \(error)")
        }
    }

    private func generateThumbnail(for pdfURL: URL) -> Data? {
        guard let document = PDFDocument(url: pdfURL),
              let page = document.page(at: 0) else { return nil }
        
        let thumbnailSize = CGSize(width: 100, height: 150)
        let renderer = UIGraphicsImageRenderer(size: thumbnailSize)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: .zero, size: thumbnailSize))
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
        
        return image.jpegData(compressionQuality: 0.8)
    }
    
    private func getUniqueFileURL() -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let uniqueFileName = UUID().uuidString + ".pdf"
        return documentsDirectory.appendingPathComponent(uniqueFileName)
    }
}
