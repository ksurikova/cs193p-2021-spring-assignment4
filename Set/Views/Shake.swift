//
//  Shake.swift
//  Set
//
//  Created by Ksenia Surikova on 17.11.2021.
//

import Foundation
import SwiftUI

struct Shake: GeometryEffect {
    
    static let defaultAmount: CGFloat  = 10
    
    var amount: CGFloat = defaultAmount
    
    init(_ i: Int) {
        animatableData = CGFloat(i)
    }
    
    var animatableData: CGFloat
    
    private func modifier(_ x: CGFloat) -> CGFloat {
        sin(x * 2 * .pi)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            0,
            y: amount * modifier(animatableData)))
    }

}

extension View {
    func shake(_ i: Int) -> some View {
        return self.modifier(Shake(i))
    }
}
