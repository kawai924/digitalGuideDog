// Created by Florian Schweizer on 21.05.22

import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView()
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) { }
}
