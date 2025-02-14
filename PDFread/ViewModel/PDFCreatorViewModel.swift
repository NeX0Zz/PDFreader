//
//  PDFCreatorViewModel.swift
//  PDFread
//
//  Created by Денис Николаев on 13.02.2025.
//


import SwiftUI
import PDFKit
import PhotosUI
import UniformTypeIdentifiers

class PDFCreatorViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var pdfURL: URL?
    @Published var isPDFCreated = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    let storage = PDFStorageService()

    func createPDF() {
        guard let image = selectedImage else { return }
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: 612, height: 792), nil)
        UIGraphicsBeginPDFPage()
        let context = UIGraphicsGetCurrentContext()
        image.draw(in: CGRect(x: 0, y: 0, width: 612, height: 792))
        UIGraphicsEndPDFContext()

        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "Generated_\(timestamp).pdf"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: fileURL)
            self.pdfURL = fileURL
            self.isPDFCreated = true
            showAlertWithMessage("PDF успешно создан!")
        } catch {
            showAlertWithMessage("Ошибка при создании PDF: \(error.localizedDescription)")
        }
    }

    func showAlertWithMessage(_ message: String) {
        alertMessage = message
        showAlert = true
    }

    func loadImage(from url: URL) {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            selectedImage = image
        }
    }
}
