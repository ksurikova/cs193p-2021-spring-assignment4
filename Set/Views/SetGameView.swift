//
//  ContentView.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameVM
    
    @Namespace private var dealingNamespace

    
    //Mark: body
    var body: some View {
        gameBody
        Spacer()
        deckBody
        HStack {
            Button("New game") {
                game.playAgain()
            }
        }
        .padding(.horizontal)
    }
    
    
    var gameBody: some View {
        AspectVGrid(items: game.model.cardsOnBoard, aspectRatio: GameViewConstants.aspectRatio, minWidth: GameViewConstants.minWidthOfCard) { card in

            if isUndealt(card) {
                Color.clear
            }
            else{
            cardView(for: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(GameViewConstants.paddingBetweenCards)
            }

        }
    }
    
    
    var deckBody : some View {
        ZStack {
            ForEach(game.model.deck + game.model.cardsOnBoard.filter{ isUndealt($0) }) {
               card in SetCardView(card)
                    .cardify(isFaceUp: isFlipped(card),
                             attributes: ShirtCardAttributes(cornerRadius: SetCardView.DrawingConstants.cardCornerRadius,
                                                             borderWidth: SetCardView.DrawingConstants.borderWidth,
                                                             colorToFill:SetCardView.DrawingConstants.normalColor))
                    .offsetDependsOnArgument(argument: isMoved(card), x: 0, y: -GameViewConstants.undealtWidth/(GameViewConstants.aspectRatio*2))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .frame(width: GameViewConstants.undealtWidth, height: GameViewConstants.undealtWidth/GameViewConstants.aspectRatio)
                    .zIndex(zIndex(of: card))
            }
        }
            .onTapGesture {
                // "deal" cards
                game.dealCards()
                let undealtCards = game.model.cardsOnBoard.filter({ isUndealt($0) })
                for index in undealtCards.indices {
                    deal(undealtCards[index])
                }
            }
            .onAppear {
                game.dealCardsForFirst()
                for index in game.model.cardsOnBoard.indices {
                    let moveDelay = Double(index)*(GameViewConstants.moveAnimationDuration + GameViewConstants.flipAnimationDuration + GameViewConstants.transitionDelay)
                    let flipDelay = moveDelay + GameViewConstants.moveAnimationDuration + 0.1
                    let dealDelay = flipDelay + GameViewConstants.flipAnimationDuration + 0.1
                    withAnimation(animationWithDelay(delay: moveDelay, duration: GameViewConstants.moveAnimationDuration)) {
                        move(game.model.cardsOnBoard[index])
                    }
                    withAnimation(animationWithDelay(delay: flipDelay, duration:GameViewConstants.flipAnimationDuration)) {
                        flip(game.model.cardsOnBoard[index])
                    }
                    withAnimation(animationWithDelay(delay: dealDelay,duration:  GameViewConstants.dealAnimationDuration)) {
                        deal(game.model.cardsOnBoard[index])
                    }
                    
                }
            }
    }
    
    //MARK: Offset card animation
    @State private var moved = Set<String>()
    
    private func move(_ card : SetCard)  {
        moved.insert(card.id)
    }
    
    private func isMoved(_ card: SetCard) -> Bool { moved.contains(card.id)}
    
    //MARK: Flip card animation
    @State private var flipped = Set<String>()
    
    private func flip(_ card : SetCard)  {
        flipped.insert(card.id)
    }
    
    private func isFlipped(_ card: SetCard) -> Bool { flipped.contains(card.id)}
    
    //MARK: Dealing cards animation
    
    @State private var dealt = Set<String>()
    
    private func deal(_ card : SetCard)  {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: SetCard) -> Bool { !dealt.contains(card.id)}
    
    
    //MARK: functions-helpers
    private func animationWithDelay(startDelay: Double, duration: Double, for index: Int) -> Animation{
        let delay = startDelay + Double(index)
        return Animation.easeInOut(duration: duration).delay(delay)
    }
    
    private func animationWithDelay(delay: Double, duration: Double) -> Animation{
        return Animation.easeInOut(duration: duration).delay(delay)
    }
    
    private func zIndex(of card: SetCard)-> Double {
        return -Double(game.model.cardsOnBoard.firstIndex{$0.id == card.id} ?? game.model.cardsOnBoard.count)
    }

    
    //MARK: card views
    private func cardView(for card: SetCard)-> some View {
        SetCardView(card)
        // to use all path tappable
            .contentShape(Rectangle())
            .onTapGesture{
                withAnimation(Animation.linear(duration: GameViewConstants.choosingAnimationDuration)){
                game.choose(card)
                }
            }
            .shake(game.justMismatchedTogglings[card.id]! ? 1 : 0)
            .glowDependsOnArgument(argument: game.justMatchedTogglings[card.id]!, color: GameViewConstants.glowColor, radius: GameViewConstants.glowRadius)
    }
    
    private struct GameViewConstants {
        static let aspectRatio: CGFloat = 2/3
        static let paddingBetweenCards: CGFloat = 4
        static let minWidthOfCard: CGFloat = 65
        static let choosingAnimationDuration: Double = 0.5
        static let dealAnimationDuration: Double = 2
        static let moveAnimationDuration: Double = 0.1
        static let flipAnimationDuration: Double = 0.5
        static let undealtWidth: CGFloat = 65
        static let glowColor: Color = .yellow
        static let glowRadius: CGFloat = 20
        static let transitionDelay : Double = 0.3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameVM()
        SetGameView(game: game)
    }
}
