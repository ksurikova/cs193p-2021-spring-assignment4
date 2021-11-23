//
//  Diamond.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//
import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let start = CGPoint(
            x: rect.midX,
            y: 0
        )
        var p = Path()
        p.move(to: start)
        let secondPoint = CGPoint(
            x: rect.maxX,
            y: rect.midY
        )
        p.addLine(to: secondPoint)
        let thirdPoint = CGPoint(
            x: rect.midX,
            y: rect.maxY
        )
        p.addLine(to: thirdPoint)
        let fourthPoint = CGPoint(
            x: 0,
            y: rect.midY
        )
        p.addLine(to: fourthPoint)
        p.addLine(to: start)
        return p
    }
    
    
}
