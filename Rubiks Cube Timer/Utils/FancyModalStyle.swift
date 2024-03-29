//
//  FancyModalStyle.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 7/22/21.
//

import SwiftUI

import CustomModalView

struct FancyModalStyle: ModalStyle {
    let animation: Animation? = .easeInOut(duration: 0.5)
        
        func makeBackground(configuration: ModalStyle.BackgroundConfiguration, isPresented: Binding<Bool>) -> some View {
            configuration.background
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.black)
                .opacity(0.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1000)
                .onTapGesture {
                    isPresented.wrappedValue = false
                }
        }
        
        func makeModal(configuration: ModalStyle.ModalContentConfiguration, isPresented: Binding<Bool>) -> some View {
            configuration.content
                //.background(Color.white)
                .background(Color(.systemGray5))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .zIndex(1001)
        }
}
