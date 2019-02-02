//
//  ViewController.swift
//  FeedBacker
//
//  Created by Francisco Amado on 02/02/2019.
//

import UIKit

import ReactiveCocoa
import ReactiveFeedback
import ReactiveSwift
import Result

enum Event {

    case increment, decrement
}

class ViewController: UIViewController {

    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        let increment = Feedback<Int, Event> { _ in
            return self.incrementButton.reactive
                .controlEvents(.touchUpInside)
                .map { _ in Event.increment }
        }

        let decrement = Feedback<Int, Event> { _ in
            return self.decrementButton.reactive
                .controlEvents(.touchUpInside)
                .map { _ in Event.decrement }
        }

        let system = SignalProducer<Int, NoError>.system(
            initial: 0, reduce: { (count, event) -> Int in
                switch event {
                case .increment:
                    return count + 1
                case .decrement:
                    return count - 1
                }
        },
            feedbacks: [increment, decrement])

        label.reactive.text <~ system.map(String.init)
    }
}
