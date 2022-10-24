//
//  ContentView.swift
//  Todos
//
//  Created by Fernando Fernandes on 24.10.22.
//

import ComposableArchitecture
import SwiftUI

struct Todo: Equatable, Identifiable {
    var description = ""
    var id: UUID
    var isComplete = false
}

struct AppState: Equatable {
    var todos: [Todo]
}

enum AppAction {
    case todoCheckboxTapped(index: Int)
    case todoTextFieldChanged(index: Int, text: String)
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .todoCheckboxTapped(index: let index):
        state.todos[index].isComplete.toggle()
        return .none
    case .todoTextFieldChanged(index: let index, text: let text):
        state.todos[index].description = text
        return .none
    }
}
    .debug()

struct ContentView: View {
    public let store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEach(Array(viewStore.todos.enumerated()), id: \.element.id) { index, todo in
                        HStack {
                            Button(action: {
                                viewStore.send(.todoCheckboxTapped(index: index))

                            }) {
                                Image(systemName: todo.isComplete ? "checkmark.square" : "square")
                            }
                            .buttonStyle(.plain)
                            TextField(
                                "Untitled todo",
                                text: viewStore.binding(
                                    get: { $0.todos[index].description },
                                    send: { .todoTextFieldChanged(index: index, text: $0) }
                                )
                            )
                        }
                        .foregroundColor(todo.isComplete ? .gray : nil)
                    }
                }
                .navigationTitle("Todos")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
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
