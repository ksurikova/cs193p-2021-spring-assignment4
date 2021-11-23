//
//  SetCardView.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import SwiftUI

struct SetCardView: View {
    
    private(set) var card: SetCard
    private(set) var symbolsCount: Int
    
    init(_ card: SetCard) {
        self.card = card
        self.symbolsCount = self.card.fourthSign.rawValue + 1
    }
    
    private func getColor(from card: SetCard) -> Color{
        var color: Color
        switch card.firstSign {
        case Sign.A : color = Color.red
        case Sign.B : color = Color.green
        case Sign.C : color = Color.purple
        }
        return color
    }
    
    @ViewBuilder
    private func getFilledSymbol(from card: SetCard) -> some View {
        let color = getColor(from: card)
        switch card.secondSign {
        case Sign.A : RoundedRectangle(cornerRadius: DrawingConstants.shapeCornerRadius).fill(color)
        case Sign.B:  Diamond().fill(color)
        case Sign.C : Rectangle().fill(color)
        }
    }
    
    @ViewBuilder
    private func getStrokedSymbol(from card: SetCard) -> some View {
        let color = getColor(from: card)
        switch card.secondSign {
        case Sign.A : RoundedRectangle(cornerRadius: DrawingConstants.shapeCornerRadius).strokeBorder(color)
        case Sign.B : Diamond().stroke(color)
        case Sign.C : Rectangle().strokeBorder(color)
        }
    }
    
    @ViewBuilder
    private func getShadedSymbol(from card: SetCard) -> some View {
        getFilledSymbol(from: card).opacity(DrawingConstants.opacity)
    }
    
    @ViewBuilder
    private func getSymbol(from card: SetCard) -> some View {
        switch card.thirdSign {
        case Sign.A :  getFilledSymbol(from: card)
        case Sign.B :  getStrokedSymbol(from: card)
        case Sign.C :  getShadedSymbol(from: card)
        }
    }


    private func getContentView(from card: SetCard)-> some View  {
        
        return GeometryReader(content: { geometry in
            if (geometry.size.width == 0 || geometry.size.height == 0)
            {
                EmptyView()
            }
            else {
                VStack(alignment: .center, spacing: 0){
                    Spacer(minLength: 0)
                    VStack(alignment: .center, spacing: DrawingConstants.spacing) {
                        let heightWithoutSpacing = geometry.size.height - (DrawingConstants.spacing * (DrawingConstants.maxSymbolsCount-1))
                        let aspectRatio = (geometry.size.width / heightWithoutSpacing)  * DrawingConstants.maxSymbolsCount

                        ForEach(Range(1...symbolsCount), id: \.self) { _ in
                            getSymbol(from: card)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
        })
    }
    
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                // border
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
                shape.fill(DrawingConstants.backgroundColor)
                shape.strokeBorder(DrawingConstants.normalColor, lineWidth: DrawingConstants.borderWidth)
                if card.isSelected {
                    shape.strokeBorder(DrawingConstants.selectedColor, lineWidth: DrawingConstants.borderWidth)
                }
                getContentView(from: self.card).padding()
            }
        }
    }
    
    struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 10
        static let shapeCornerRadius: CGFloat = 40
        static let borderWidth: CGFloat = 5
        static let spacing: CGFloat = 10
        static let padding: CGFloat = 3
        static let opacity: CGFloat = 0.25
        static let backgroundColor: Color = Color.white
        static let normalColor: Color = Color.purple
        static let selectedColor: Color = Color.red
        static let matchColor: Color = Color.yellow
        static let mismatchedColor: Color = Color.black
        static let maxSymbolsCount: CGFloat = 3
    }
}


struct SetCardView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardView(SetCard(Sign.C, Sign.A, Sign.C, Sign.B))
    }
}



