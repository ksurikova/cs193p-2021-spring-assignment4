//
//  SetGameVM.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import Foundation

class SetGameVM: ObservableObject {
    
    @Published private(set) var model: SetGame
    
    @Published private(set) var justMismatchedTogglings = Dictionary<String, Bool>()
    @Published private(set) var justMatchedTogglings = Dictionary<String, Bool>()
    
    
    init() {
        model = SetGame()
        for index in model.deck.indices {
            justMismatchedTogglings[model.deck[index].id] = false
            justMatchedTogglings[model.deck[index].id] = false
        }
    }
    
    //Mark: - Intent(s)
    func choose(_ card: SetCard) {
        // don't need more, because we set @Published directive to model var
        //objectWillChange.send()
        model.choose(card)
        
        
        if let set = model.isSet{
            if set == false {
                model.cardsOnBoard.filter{$0.isSelected}.forEach {
                    justMismatchedTogglings[$0.id]?.toggle()
                }
            }
            else {
                model.cardsOnBoard.filter{$0.isSelected}.forEach {
                    justMatchedTogglings[$0.id]?.toggle()
                }
            }
        }
    }
    
    func playAgain() {
        model = SetGame()
        for index in model.deck.indices {
            justMismatchedTogglings[model.deck[index].id] = false
            justMatchedTogglings[model.deck[index].id] = false
        }
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func canDealMoreCards() -> Bool {
        return model.canDealMoreCards()
    }
    
    func dealCardsForFirst() {
        model.dealCardsForFirst()
    }
    
}

