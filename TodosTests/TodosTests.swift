import ComposableArchitecture
import XCTest
@testable import Todos

final class TodosTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testCompletingTodo() {
        let store = TestStore(
            initialState: AppState(
                todos: [
                    Todo(
                        description: "Milk",
                        id: UUID(),
                        isComplete: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                uuid: {
                    fatalError("This test shouldn't have this dependency")
                }
            )
        )

        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.todos[0].isComplete = true
            },
            .do {
                self.scheduler.advance(by: 1)
            },
            .receive(.todoDelayCompleted)
        )
    }

    func testAddTodo() {
        let store = TestStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                uuid: { UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFDEAD")! }
            )
        )

        store.assert(
            .send(.addButtonTapped) {
                $0.todos = [
                    Todo(
                        description: "",
                        id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFDEAD")!,
                        isComplete: false
                    )
                ]
            }
        )
    }

    func testTodoSorting() {
        let store = TestStore(
            initialState: AppState(
                todos: [
                    Todo(
                        description: "Milk",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        isComplete: false
                    ),
                    Todo(
                        description: "Egg",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                        isComplete: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                uuid: {
                    fatalError("This test shouldn't have this dependency")
                }
            )
        )

        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.todos[0].isComplete = true
            },
            .do {
                self.scheduler.advance(by: 1)
            },
            .receive(.todoDelayCompleted) {
                $0.todos.swapAt(0, 1)
            }
        )
    }

    func testTodoSorting_Cancelation() {
        let store = TestStore(
            initialState: AppState(
                todos: [
                    Todo(
                        description: "Milk",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        isComplete: false
                    ),
                    Todo(
                        description: "Egg",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                        isComplete: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                uuid: {
                    fatalError("This test shouldn't have this dependency")
                }
            )
        )

        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.todos[0].isComplete = true
            },
            .do {
                self.scheduler.advance(by: 0.5)
            },
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.todos[0].isComplete = false
            },
            .do {
                self.scheduler.advance(by: 1)
            },
            .receive(.todoDelayCompleted)
        )
    }
}
