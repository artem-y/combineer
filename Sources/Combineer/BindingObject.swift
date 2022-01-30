//
//  BindingObject.swift
//
//
//  Created by Artem Yelizarov on 4.12.2021.
//

import Combine
import Foundation

/// Provides conforming values with `bind` method implementation to simplify subscriptions.
public protocol BindingObject: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

extension BindingObject {
    /// Attaches subscriber with passed handler closures and stores it in `cancellables`.
    /// - parameter publisher: Publisher to subscribe `self` to.
    /// - parameter valueHandler: Closure that handles value received from the publisher.
    /// - parameter completionHandler: Closure that handles completion sent by the publisher.
    public func bind<BindablePublisher: Publisher>(
        _ publisher: BindablePublisher,
        valueHandler: @escaping (BindablePublisher.Output) -> Void,
        completionHandler: @escaping (Subscribers.Completion<BindablePublisher.Failure>) -> Void = { _ in }
    ) {
        publisher
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }

    /// Attaches subscriber with passed handler closures, receiving on `DispatchQueue.main` without options
    /// and stores it in `cancellables`.
    /// - parameter publisher: Publisher to subscribe `self` to.
    /// - parameter valueHandler: Closure that handles value received from the publisher.
    /// - parameter completionHandler: Closure that handles completion sent by the publisher.
    public func bindOnMainQueue<BindablePublisher: Publisher>(
        _ publisher: BindablePublisher,
        valueHandler: @escaping (BindablePublisher.Output) -> Void,
        completionHandler: @escaping (Subscribers.Completion<BindablePublisher.Failure>) -> Void = { _ in }
    ) {
        let publisherOnMainQueue = publisher.receive(on: DispatchQueue.main)
        bind(publisherOnMainQueue, valueHandler: valueHandler, completionHandler: completionHandler)
    }

    /// Attaches the output of a publisher to a subject and stores the subscription in `cancellables.
    ///
    /// Example:
    /// ```
    ///  bind(publisher, to: subject)
    /// ```
    ///
    /// - parameter publisher: Publisher that will be sending values to subject.
    /// - parameter subject: Subject that will receive values from the attached publisher.
    public func bind<BindablePublisher: Publisher, ReceivingSubject: Subject>(
        _ publisher: BindablePublisher,
        to subject: ReceivingSubject
    ) where ReceivingSubject.Output == BindablePublisher.Output,
            ReceivingSubject.Failure == BindablePublisher.Failure {

                publisher
                    .subscribe(subject)
                    .store(in: &cancellables)
            }
}
