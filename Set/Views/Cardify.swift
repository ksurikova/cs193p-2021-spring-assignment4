//
//  Cardify.swift
//  Set
//
//  Created by Ksenia Surikova on 19.11.2021.
//
import SwiftUI

struct ShirtCardAttributes{
    private(set) var cornerRadius: CGFloat
    private(set) var borderWidth: CGFloat
    private(set) var colorToFill: Color
    
    init(cornerRadius: CGFloat, borderWidth: CGFloat, colorToFill: Color){
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.colorToFill = colorToFill
    }
}

struct Cardify: AnimatableModifier {
    
    
    private(set) var attributes: ShirtCardAttributes
    var rotation: Double // in degrees
    var animatableData: Double {
        get {rotation}
        set {rotation = newValue}
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: attributes.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: attributes.borderWidth)
            }
            else {
                shape.fill(attributes.colorToFill)
            }
            content.opacity(rotation < 90 ? 1: 0 )
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }

    
    init(isFaceUp: Bool, attributes: ShirtCardAttributes) {
        rotation = isFaceUp ? 0 : 180
        self.attributes = attributes
    }
}

extension View {
    func cardify(isFaceUp: Bool, attributes: ShirtCardAttributes) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp, attributes: attributes))
    }
}

