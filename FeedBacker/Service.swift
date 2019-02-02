//
//  Service.swift
//  FeedBacker
//
//  Created by Francisco Amado on 02/02/2019.
//

import Foundation

import ReactiveCocoa
import ReactiveFeedback
import ReactiveSwift
import Result

class Service {

    let status: Property<Service.Status>

    private let state: Property<Service.State>

    private let incrementSignal: Signal<Void, NoError>
    let incrementObserver: Signal<Void, NoError>.Observer

    private let decrementSignal: Signal<Void, NoError>
    let decrementObserver: Signal<Void, NoError>.Observer

    init() {

        (incrementSignal, incrementObserver) = Signal.pipe()
        (decrementSignal, decrementObserver) = Signal.pipe()

        state = Property(initial: State.count(0),
                         reduce: Service.reduce,
                         feedbacks: [Feedbacks.increment(incrementSignal),
                                     Feedbacks.decrement(decrementSignal)])

        status = Property(initial: .count(0), then: state.signal.map { $0.status })
    }
}

extension Service {

    enum Status {

        case count(Int)
    }
}

private extension Service {

    enum State {

        case count(Int)

        var status: Service.Status {
            switch self {
            case .count(let value):
                return .count(value)
            }
        }

        var count: Int {
            switch self {
            case .count(let value):
                return value
            }
        }
    }

    enum Event {
        case increment
        case decrement
    }

    enum Feedbacks {

        static func increment(_ signal: Signal<Void, NoError>) -> Feedback<State, Event> {
            return Feedback(events: { _, _ in
                signal.map { _ in Event.increment }
            })
        }

        static func decrement(_ signal: Signal<Void, NoError>) -> Feedback<State, Event> {
            return Feedback(events: { _, _ in
                signal.map { _ in Event.decrement }
            })
        }
    }


    static func reduce(state: State, event: Event) -> State {

        switch event {
        case .increment:
            return .count(state.count + 1)
        case .decrement:
            return .count(state.count - 1)
        }
    }
}
