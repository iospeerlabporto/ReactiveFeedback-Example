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

class ViewController: UIViewController {

    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var label: UILabel!

    let service: Service

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        service = Service()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {

        service = Service()

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        incrementButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [unowned self] _ in
                self.service.incrementObserver.send(value: ())
            }

        decrementButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { [unowned self] _ in
                self.service.decrementObserver.send(value: ())
            }

        service.status.signal.observeValues({
            print($0)
        })

        label.reactive.text <~ service.status.signal
            .map { status -> String in
                switch status {
                case .count(let int):
                    return String(int)
                }
            }
    }
}
