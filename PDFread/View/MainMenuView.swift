//
//  MainMenuView.swift
//  PDFread
//
//  Created by Денис Николаев on 12.02.2025.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: PDFCreatorView()) {
                MenuButton(title: "Создать PDF", icon: "doc.badge.plus")
            }
            
            NavigationLink(destination: DocumentListView()) {
                MenuButton(title: "Мои документы", icon: "folder")
            }
            
            NavigationLink(destination: PDFEditorView()) {
                MenuButton(title: "Редактировать PDF", icon: "pencil")
            }
        }
        .navigationTitle("Главное меню")
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(.trailing, 10)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .padding(.horizontal, 40)
    }
}
