//
//  Service.swift
//  Service
//
//  Created by Luis Gustavo on 20/03/23.
//

public class Services {

    // MARK: - Properties
    public static let `default` = Services()
    private var registers = [ObjectIdentifier: () -> Any]()

    // MARK: - Methods
    public func register<S, R>(_ service: S.Type, maker: @escaping () -> R) {
        registers[ObjectIdentifier(service)] = maker
    }

    public func make<S, R>(for service: S.Type) -> R {
        let id = ObjectIdentifier(service)
        guard let maker = registers[id] else {
            fatalError(
                Localizable.serviceWasntPreviouslyRegistered(
                    .init(describing: service)
                ).localized
            )
        }
        guard let casted = maker() as? R else {
            fatalError(
                Localizable.serviceCantBeDowncasted(
                    String(describing: service),
                    .init(describing: R.self)
                ).localized)
        }
        return casted
    }
}

// MARK: - Util extensions
public extension Services {
    static func register<S, R>(_ service: S.Type, maker: @escaping () -> R) {
        Services.default.register(service, maker: maker)
    }

    static func make<S, R>(for service: S.Type) -> R {
        return Services.default.make(for: service)
    }
}
