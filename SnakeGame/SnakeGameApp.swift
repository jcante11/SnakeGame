//
//  SnakeGameApp.swift
//  SnakeGame
//
//  Created by Juan Cante Jr. on 10/8/24.
//

import SwiftUI

@main
struct SnakeGameApp: App {
    
    @StateObject var appState = AppState.shared
    var body: some Scene {
        WindowGroup {
            ContentView().id(appState.gameID)
        }
    }
}


//create a global app state
class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var gameID = UUID()
}
