//
//  SolveMoreInfoView.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 7/22/21.
//

import SwiftUI

struct SolveMoreInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack {
                Text("27.89").font(.system(.largeTitle, design: .rounded)).bold()
                Spacer()
                VStack(alignment: .trailing, content: {
                    Text("2021/08/13")
                    Text("8:39 PM")
                })
                
            }
            // text.bubble
            Text("B2 R2 U2 F U2 F' R2 F' L2 B2 R2 B' U F' R' B F2 L B2 R B").padding(.top)

            HStack {
                Image(systemName: "text.bubble").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                Text("Comment text")
            }.padding(.top)
            
            Button(action: {}, label: {
                Label("Delete", systemImage: "trash")
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }).padding(.vertical)
        }).padding()
    }
}

struct SolveMoreInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SolveMoreInfoView()
    }
}
