protocol UnitType {
    associatedtype Input
    associatedtype Output
    associatedtype Event = Never
    typealias Router = AnyRouter<Event>
}
