//
//  SetApp.swift
//  Set
//
//  Created by Ksenia Surikova on 13.10.2021.
//

import SwiftUI

@main
struct SetApp: App {
    
    private let game = SetGameVM()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
    
    
//    private let game = TestVM()
//    var body: some Scene {
//        WindowGroup {
//            TestView(game: game)
//        }
//    }
}
