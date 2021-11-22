//
//  SetCard.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import Foundation

enum Sign: Int, CustomStringConvertible, CaseIterable {
    case A
    case B
    case C
    
    var description: String {
       get {
         switch self {
           case .A:
             return "A"
           case .B:
             return "B"
           case .C:
             return "C"
         }
       }
    }
}

struct SetCard: CustomStringConvertible, Equatable, Identifiable {
   
    var id: String {
        description
       }
    
    private(set) var firstSign : Sign
    private(set) var secondSign : Sign
    private(set) var thirdSign : Sign
    private(set) var fourthSign : Sign
    // надо ли держать именно здесь, не уверена
    var isSelected = false {
        didSet {
            // если мы сняли выделение, то в match карта точно не участвует
            if oldValue {
                isMatched = nil
            }
        }
    }
    var isMatched: Bool?
    
    // признак равенства
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        return
            lhs.firstSign == rhs.firstSign && lhs.secondSign == rhs.secondSign && lhs.thirdSign == rhs.thirdSign && lhs.fourthSign == rhs.fourthSign
    }
    
    init (_ firstSign: Sign, _ secondSign: Sign, _ thirdSign: Sign , _ fourthSign: Sign){
        self.firstSign = firstSign
        self.secondSign = secondSign
        self.thirdSign = thirdSign
        self.fourthSign = fourthSign
    }
    
    var description: String {
        return "\(firstSign)\(secondSign)\(thirdSign)\(fourthSign)"
    }
    
    static func isSet(cardsToCheck: [SetCard])-> Bool? {
        guard cardsToCheck.count == SetGame.cardsToDealAndCheckCount else {return nil}
        // find sum for some sign in checked cards
      let signsSum = [
        cardsToCheck.reduce(0, {$0 + $1.firstSign.rawValue}),
        cardsToCheck.reduce(0, {$0 + $1.secondSign.rawValue}),
        cardsToCheck.reduce(0, {$0 + $1.thirdSign.rawValue}),
        cardsToCheck.reduce(0, {$0 + $1.fourthSign.rawValue})
      ]
       // return true
        return signsSum.reduce(true, {$0 && ($1 % 3 == 0)})
    }
}
