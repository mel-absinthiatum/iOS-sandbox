import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
    /** Pass the value to the specified router and discard it (replacing with Void()). */
    func route<R>(with router: R) -> SharedSequence<SharingStrategy, Void>
        where R: RouterType, E == R.Event {
            return self.asSharedSequence().do(onNext: router.play(event:))
                .map({ _ in () })
    }
}
