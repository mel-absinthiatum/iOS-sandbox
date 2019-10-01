protocol RouterType {
    associatedtype Event
    
    func play(event: Event)
}

final class AnyRouter<Event>: RouterType {
    private let _playEvent: (Event) -> Void
    
    init<C>(_ coordinator: C) where C: RouterType, C.Event == Event {
        self._playEvent = coordinator.play(event:)
    }
    
    init(play: @escaping (Event) -> Void) {
        self._playEvent = play
    }
    
    func play(event: Event) {
        _playEvent(event)
    }
}

extension RouterType {
    func asRouter() -> AnyRouter<Event> {
        return .init(self)
    }
}
