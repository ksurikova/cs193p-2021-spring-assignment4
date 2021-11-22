//
//  UIExtensions.swift
//  Set
//
//  Created by Ksenia Surikova on 17.11.2021.
//

import Foundation
import SwiftUI

extension View {
    func glow(color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
    
    @ViewBuilder
    func glowDependsOnArgument(argument: Bool, color: Color, radius: CGFloat) -> some View {
        if argument {
            self.glow(color: color, radius: radius)
        }
        else {
            self
        }
    }
    
    
    @ViewBuilder
    func offsetDependsOnArgument(argument: Bool, x: CGFloat, y: CGFloat) -> some View {
        if argument {
            self.offset(x: x, y: y)
        }
        else {
            self
        }
    }
}

