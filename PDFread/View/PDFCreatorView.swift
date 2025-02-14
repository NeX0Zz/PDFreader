//
//  PDFCreatorView.swift
//  PDFread
//
//  Created by Денис Николаев on 12.02.2025.
//

import SwiftUI

struct PDFCreatorView: View {
    @StateObject private var viewModel = PDFCreatorViewModel()
    @State private var isImagePickerPresented = false
    @State private var isFilePickerPresented = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                } else {
                    Text("Выберите изображение")
                        .foregroundColor(.gray)
                        .font(.title3)
                }

                if !viewModel.isPDFCreated {
                    HStack {
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            Text("Выбрать из галереи")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }

                        Button(action: {
                            isFilePickerPresented = true
                        }) {
                            Text("Выбрать из файлов")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                    }
                }

                if viewModel.selectedImage != nil && !viewModel.isPDFCreated {
                    Button(action: {
                        viewModel.createPDF()
                    }) {
                        Text("Создать PDF")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                }

                if let pdfURL = viewModel.pdfURL {
                    VStack(spacing: 10) {
                        Button(action: {
                            viewModel.storage.saveDocument(title: "Новый документ", pdfURL: pdfURL)
                            viewModel.showAlertWithMessage("PDF успешно сохранён в мои документы!")
                        }) {
                            Text("Сохранить PDF")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }

                        NavigationLink("Открыть PDF", destination: PDFReaderView(pdfURL: pdfURL))
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 20)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()

            Spacer()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $viewModel.selectedImage)
        }
        .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let url):
                viewModel.loadImage(from: url)
            case .failure(let error):
                print("Ошибка при выборе файла: \(error.localizedDescription)")
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Успешно!"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Создать PDF")
        .navigationBarTitleDisplayMode(.inline)
    }
}
