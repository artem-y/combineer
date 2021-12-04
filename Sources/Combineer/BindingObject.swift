//
//  BindingObject.swift
//
//
//  Created by Artem Yelizarov on 4.12.2021.
//

import Combine

/// Provides conforming values with `bind` method implementation to simplify subscriptions.
protocol BindingObject: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

extension BindingObject {
    func bind<BindablePublisher: Publisher>(
        _ publisher: BindablePublisher,
        valueHandler: @escaping (BindablePublisher.Output) -> Void,
        completionHandler: @escaping (Subscribers.Completion<BindablePublisher.Failure>) -> Void = { _ in }
    ) {
        publisher
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
}
