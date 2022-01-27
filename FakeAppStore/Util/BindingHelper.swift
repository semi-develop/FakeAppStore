//
//  BindingHelper.swift
//  BindingTest
//
//  Created by semi on 2022/01/12.
//


class Observable<T> {

    private var listener: ((T) -> Void)?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func subscribe(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }

}

