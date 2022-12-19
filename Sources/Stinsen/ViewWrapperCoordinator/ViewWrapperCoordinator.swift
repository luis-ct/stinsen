import Foundation
import SwiftUI

/// The NavigationViewCoordinator is used to represent a coordinator with a NavigationView

public protocol ViewWrapperCoordinatable: Coordinatable {
    associatedtype RouterStoreType
    var routerStorable: RouterStoreType { get }
}

public extension ViewWrapperCoordinatable {
    var routerStorable: Self {
        get {
            self
        }
    }
}

open class ViewWrapperCoordinator<T: Coordinatable, V: View>: Coordinatable {
    public func dismissChild<T: Coordinatable>(coordinator: T, action: (() -> Void)?) {
        guard let parent = self.parent else {
            assertionFailure("Can not dismiss a coordinator since no coordinator is presented.")
            return
        }
        
        parent.dismissChild(coordinator: self, action: action)
    }

    public weak var parent: ChildDismissable?
    public let child: T

    private let viewFactory: (any Coordinatable) -> (AnyView) -> V
//    private let router: NavigationRouter<T>

    public func view() -> AnyView {
        AnyView(
            ViewWrapperCoordinatorView(coordinator: self, viewFactory(self))
        )
    }
    
    public init(_ childCoordinator: T, _ view: @escaping (AnyView) -> V) {
        self.child = childCoordinator
        self.viewFactory = { _ in { view($0) } }
//        self.router = NavigationRouter(
//            id: -1,
//            coordinator: child.routerStorable as T
//        )
        self.child.parent = self

//        RouterStore.shared.store(router: router)
    }
    
    public init(_ childCoordinator: T, _ view: @escaping (any Coordinatable) -> (AnyView) -> V) {
        self.child = childCoordinator
        self.viewFactory = view
//        self.router = NavigationRouter(
//            id: -1,
//            coordinator: child.routerStorable as T
//        )
        self.child.parent = self

//        RouterStore.shared.store(router: router)
    }

    var routerStorable: Self {
        get {
            self
        }
    }
}

public extension ViewWrapperCoordinator {}
