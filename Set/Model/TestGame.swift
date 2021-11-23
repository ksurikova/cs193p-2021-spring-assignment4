//
//  TestGame.swift
//  Set
//
//  Created by Ksenia Surikova on 24.11.2021.
//

import Foundation

struct TestGame {
    static let cardsToDealAndCheckCount = 3
    static let cardsCountForFirstDeal = 12
    
    private(set) var deck: [SetCard]
    private(set) var cardsOnBoard: [SetCard]
    private(set) var deal: [SetCard]
    
    private var selectedCardsIndices : [Int] { get {return cardsOnBoard.indices.filter{cardsOnBoard[$0].isSelected}}}
    
    
    func canDealMoreCards(countToDeal : Int = SetGame.cardsToDealAndCheckCount) -> Bool { deck.count >= countToDeal }
    
    mutating func dealCards(){
        guard canDealMoreCards() else {return }
        deal = [SetCard]()
        for _ in 0..<SetGame.cardsToDealAndCheckCount {
            let elem = deck.removeFirst()
            cardsOnBoard.append(elem)
            deal.append(elem)
        }
    }
    
    
    init() {
        deck = TestGame.getDeck()
        cardsOnBoard = [SetCard]()
        deal = [SetCard]()
    }
    
    mutating func dealCardsForFirst()  {
        cardsOnBoard = Array(deck.prefix(SetGame.cardsCountForFirstDeal))
        deal = cardsOnBoard
        deck.removeSubrange(0..<SetGame.cardsCountForFirstDeal)
    }
    
    
    private static func getDeck() -> [SetCard] {
        var deck = [SetCard]()
        for i in Sign.allCases {
            for j in Sign.allCases {
                for k in Sign.allCases {
                    for l in Sign.allCases {
                        let card = SetCard(i,j,k,l)
                        deck.append(card)
                    }
                }
            }
        }
        return deck.shuffled()
    }
}

