//
//  MaterialEffect.swift
//  MaterialEffect
//
//  Created by 1 on 14/09/21.
//

import SwiftUI

struct MaterialEffect: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}


