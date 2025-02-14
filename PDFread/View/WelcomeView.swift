//
//  WelcomeView.swift
//  PDFread
//
//  Created by Денис Николаев on 12.02.2025.
//


import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Добро пожаловать!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text("Создавайте, редактируйте и управляйте PDF-документами прямо на вашем устройстве.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                NavigationLink(destination: MainMenuView()) {
                    Text("Начать")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}
