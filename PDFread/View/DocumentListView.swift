//
//  DocumentListView.swift
//  PDF reader
//
//  Created by Денис Николаев on 12.02.2025.
//

import SwiftUI
import RealmSwift
import PDFKit

struct DocumentListView: View {
    @StateObject private var viewModel = DocumentListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.documents, id: \.id) { document in
                HStack {
                    if viewModel.selectedDocumentForMerge == document {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                            .padding(.leading, 8)
                    }
                    NavigationLink(destination: PDFReaderView(pdfURL: URL(fileURLWithPath: document.filePath))) {
                        HStack {
                            if let thumbnailData = document.thumbnailData,
                               let image = UIImage(data: thumbnailData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 50, height: 70)
                                    .cornerRadius(8)
                            }
                            VStack(alignment: .leading) {
                                Text(document.title).font(.headline)
                                Text("Создано: \(document.createdAt.formatted())")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.delete(document: document)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }

                    Button {
                        viewModel.share(document: document)
                    } label: {
                        Label("Поделиться", systemImage: "square.and.arrow.up")
                    }

                    if !viewModel.isSelectingForMerge {
                        Button {
                            viewModel.startSelectingForMerge(document: document)
                        } label: {
                            Label("Объединить", systemImage: "plus.app")
                        }
                    } else {
                        Button {
                            viewModel.mergeWithSelectedDocument(document: document)
                        } label: {
                            Label("Завершить объединение", systemImage: "doc.fill")
                        }
                    }
                }
            }
        }
        .navigationTitle("Мои PDF")
        .onAppear {
            viewModel.loadDocuments()
        }
    }
}
