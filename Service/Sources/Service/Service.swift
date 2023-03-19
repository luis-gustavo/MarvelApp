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
            fatalError("Service '\(service)' wasn't previously registered")
        }
        guard let casted = maker() as? R else {
            fatalError("Service '\(service)' can't be downcasted to '\(R.self)'.")
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
