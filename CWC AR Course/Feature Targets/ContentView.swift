// Created by Florian Schweizer on 21.05.22

import SwiftUI

struct ContentView: View {
    @State private var colors: [Color] = [
        .green,
        .red,
        .blue
    ]
    
    var body: some View {
        CustomARViewRepresentable()
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                ScrollView(.horizontal) {
                    HStack {
                        
                        
                        Button("Place") {
                            ARManager.shared.actionStream.send(.placeSkateboard)
                        }
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        
                        Button("360") {
                            ARManager.shared.actionStream.send(.playSkateboardAnimation)
                        }
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        
                        Button {
                            ARManager.shared.actionStream.send(.removeAllAnchors)
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(16)
                        }
                        
                        ForEach(colors, id: \.self) { color in
                            Button {
                                ARManager.shared.actionStream.send(.placeBlock(color: color))
                            } label: {
                                color
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(.regularMaterial)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
