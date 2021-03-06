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
    @Namespace private var discardingNamespace

    
    //Mark: body
    var body: some View {
        VStack {
            gameBody
            Spacer()
            HStack {
                deckBody
                Spacer()
                discardBody
            }
            Button("New game") {
                playAgain()
            }
        }
        .padding(.horizontal)
    }
    
    
    var gameBody: some View {
        AspectVGrid(items: game.model!.cardsOnBoard, aspectRatio: GameViewConstants.aspectRatio, minWidth: GameViewConstants.minWidthOfCard) { card in
            if isUndealt(card) || game.model!.discarded.contains{$0.id == card.id} {
                Color.clear
            }
            else{
                cardView(for: card)
                    .padding(GameViewConstants.paddingBetweenCards)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
            }
        }
    }
    
    var discardBody: some View {
        ZStack {
            ForEach(game.model!.discarded) {
                card in SetCardView(card)
                    .frame(width: GameViewConstants.undealtWidth, height: GameViewConstants.undealtWidth/GameViewConstants.aspectRatio)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
            }
        }
    }
    
    
    var deckBody: some View {
        ZStack {
            ForEach(game.model!.deck + game.model!.cardsOnBoard.filter{ isUndealt($0) }) {
               card in SetCardView(card)
                    .cardify(isFaceUp: isFlipped(card),
                             attributes: ShirtCardAttributes(cornerRadius: SetCardView.DrawingConstants.cardCornerRadius,
                                                             borderWidth: SetCardView.DrawingConstants.borderWidth,
                                                             colorToFill:SetCardView.DrawingConstants.normalColor))
                    .frame(width: GameViewConstants.undealtWidth, height: GameViewConstants.undealtWidth/GameViewConstants.aspectRatio)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))
            }
        }
            .onTapGesture {
                // "deal" cards
                withAnimation(Animation.easeInOut(duration: GameViewConstants.rearrangeAnimationDuration)) {
                    game.dealCards()
                }
                animateDealingCards(game.model!.deal, startDelay: 0)
            }
            .onAppear {
                game.dealCardsForFirst()
                animateDealingCards(game.model!.deal, startDelay: 0)
            }
    }
    
    //MARK: Play again
    private func playAgain(){
        flipped = Set<String>()
        dealt = Set<String>()
        game.play()
        game.dealCardsForFirst()
        animateDealingCards(game.model!.deal, startDelay: 0)
    }
    
    
    //MARK: Animate appearing cards
    private func animateDealingCards(_ cards: [SetCard], startDelay: Double) {
        for index in cards.indices {
            let flipDelay = Double(index)*(GameViewConstants.flipAnimationDuration + GameViewConstants.transitionDelay) + startDelay
            let dealDelay = flipDelay + GameViewConstants.flipAnimationDuration
            withAnimation(animationWithDelay(delay: flipDelay, duration: GameViewConstants.flipAnimationDuration)) {
                flip(cards[index])
            }
            withAnimation(animationWithDelay(delay: dealDelay, duration: GameViewConstants.dealAnimationDuration)) {
                deal(cards[index])
            }
        }
    }
    
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
    
    
    private func animationWithDelay(delay: Double, duration: Double) -> Animation{
        return Animation.easeInOut(duration: duration).delay(delay)
    }
    
    private func zIndex(of card: SetCard)-> Double {
        return -Double(game.model!.cardsOnBoard.firstIndex{$0.id == card.id} ?? game.model!.cardsOnBoard.count)
    }

    
    //MARK: card views
    private func cardView(for card: SetCard)-> some View {
        SetCardView(card)
        // to use all path tappable
            .contentShape(Rectangle())
            .onTapGesture{
               // withAnimation(Animation.linear(duration: GameViewConstants.choosingAnimationDuration)){
                    game.choose(card)
               // }
                animateDealingCards(game.model!.deal, startDelay: 0)
                withAnimation(Animation.linear(duration: GameViewConstants.toggleAnimationDuration)){
                    game.toggleCards()
                }
            }
            .shake(game.justMismatchedTogglings[card.id]! ? 1 : 0)
            .glowDependsOnArgument(argument: game.justMatchedTogglings[card.id]!, color: GameViewConstants.glowColor, radius: GameViewConstants.glowRadius)
    }
    
    private struct GameViewConstants {
        static let aspectRatio: CGFloat = 2/3
        static let paddingBetweenCards: CGFloat = 4
        static let minWidthOfCard: CGFloat = 65
        static let choosingAnimationDuration: Double = 0.9
        static let toggleAnimationDuration: Double = 0.5
        static let rearrangeAnimationDuration: Double = 0.5
        static let dealAnimationDuration: Double = 0.5
        static let flipAnimationDuration: Double = 0.5
        static let undealtWidth: CGFloat = 65
        static let glowColor: Color = .yellow
        static let glowRadius: CGFloat = 10
        static let transitionDelay : Double = 0.1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameVM()
        SetGameView(game: game)
    }
}
