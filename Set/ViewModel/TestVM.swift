//
//  TestVM.swift
//  Set
//
//  Created by Ksenia Surikova on 24.11.2021.
//

import Foundation
import SwiftUI

class TestVM: ObservableObject {
    
    @Published private(set) var model: TestGame?
    
    @Published  var onBoardNow: Set<String> = Set<String>()
    
    init() {
        play()
    }
    
    
    func play() {
        model = TestGame()
    }
    
    func dealCards() {
        model!.dealCards()
        onBoardNow = model!.cardsOnBoard.map{$0.id}.subtract(from: model!.deal.map{$0.id})
    }
    
    func canDealMoreCards() -> Bool {
        return model!.canDealMoreCards()
    }
    
    func dealCardsForFirst() {
        model!.dealCardsForFirst()
        onBoardNow = model!.cardsOnBoard.map{$0.id}.subtract(from: model!.deal.map{$0.id})
    }
    
    @Published var uiLastSize: CGSize = CGSize(width:0, height:0)
    
    public func render(_ size:CGSize) -> Bool {
        guard size != CGSize.zero else { return false }
        if size != uiLastSize {
            uiLastSize = size
        }
        return true
    }
    
}

extension Array where Element: Hashable {
    func subtract(from other: [Element]) -> Set<Element> {
        var thisSet = Set(self)
        let otherSet = Set(other)
        thisSet.subtract(otherSet)
        return thisSet
    }
}




