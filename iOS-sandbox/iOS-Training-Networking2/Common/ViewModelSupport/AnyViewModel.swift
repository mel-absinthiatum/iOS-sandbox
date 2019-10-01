protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

class AnyViewModel<I, O>: ViewModelType {
    typealias Input = I
    typealias Output = O
    
    private let _transform: (I) -> O
    
    init<VM: ViewModelType>(_ viewModel: VM) where VM.Input == I, VM.Output == O {
        self._transform = viewModel.transform
    }
    
    func transform(_ input: I) -> O {
        return _transform(input)
    }
}

