//
//  SessionSelector.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI

struct Ingredient{
        var id = UUID()
        var name: String
        var isSelected: Bool = false
}

struct SessionSelector: View {
    @State var ingredients: [Ingredient] = [Ingredient(name: "Salt"),
                                            Ingredient(name: "Pepper"),
                                            Ingredient(name: "Chili"),
                                            Ingredient(name: "Milk")]
    
    var list = ["Default", "b", "c", "d"]
    @State var selected = 0
    
    var body: some View {
        List{
            ForEach(0..<list.count){ index in
                HStack {
                    Button(action: {
                        selected = index
                    }) {
                        HStack{
                            if index == selected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .animation(.easeIn)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.primary)
                                    .animation(.easeOut)
                            }
                            Text(list[index])
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
}

struct SessionSelector_Previews: PreviewProvider {
    static var previews: some View {
        SessionSelector()
    }
}
