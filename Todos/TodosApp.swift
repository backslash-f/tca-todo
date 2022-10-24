//
//  TodosApp.swift
//  Todos
//
//  Created by Fernando Fernandes on 24.10.22.
//

import ComposableArchitecture
import SwiftUI

@main
struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(
                        todos: [
                            Todo(
                                description: "Milk",
                                id: UUID(),
                                isComplete: false
                            ),
                            Todo(
                                description: "Eggs",
                                id: UUID(),
                                isComplete: false
                            ),
                            Todo(
                                description: "Hand Soap",
                                id: UUID(),
                                isComplete: true
                            )
                        ]
                    ),
                    reducer: appReducer,
                    environment: AppEnvironment()
                )
            )
        }
    }
}
