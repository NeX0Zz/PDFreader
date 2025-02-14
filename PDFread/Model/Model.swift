//
//  Model.swift
//  PDFread
//
//  Created by Денис Николаев on 12.02.2025.
//

import SwiftUI
import RealmSwift

class PDFDocumentModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String
    @Persisted var filePath: String
    @Persisted var createdAt: Date
    @Persisted var thumbnailData: Data?
    
    convenience init(title: String, filePath: String, thumbnail: Data?) {
        self.init()
        self.title = title
        self.filePath = filePath
        self.createdAt = Date()
        self.thumbnailData = thumbnail
    }
}
