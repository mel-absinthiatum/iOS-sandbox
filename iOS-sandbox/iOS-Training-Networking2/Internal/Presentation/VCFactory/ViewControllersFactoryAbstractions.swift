import UIKit

/// The implementation of View Controllers Factory abstracion using type erasure,
///
/// VCInfo protocol describes the meta information about the view controller
/// neccessary to construct the sceene: VC type, storyBoard name in default bundle
/// (as the only default bundle is used in this project) and the view controller
/// storyboard identifier.
///
/// The `AnyVCInfo` wraper is intended to overtake the language generic restriction
/// of using implementations of protocols with assosiated types.

protocol VCInfo {
    associatedtype ViewControllerType: UIViewController
    var storyboardName: String { get }
    var vcId: String { get }
}

extension VCInfo {
    func asAnyVCInfo() -> AnyVCInfo<ViewControllerType> {
        return AnyVCInfo(vcInfo: self)
    }
}

struct AnyVCInfo<VCType: UIViewController>: VCInfo {
    typealias ViewControllerType = VCType
    private let box: _AnyVCInfoBase<VCType>
    var vcId: String {
        return box.vcId
    }
    
    var storyboardName: String {
        return box.storyboardName
    }
    
    init<VCI: VCInfo>(vcInfo: VCI) where VCI.ViewControllerType == VCType {
        self.box = _AnyVCInfoBox(vcInfo: vcInfo)
    }
}

private class _AnyVCInfoBase<VCType: UIViewController>: VCInfo {
    typealias ViewControllerType = VCType
    var vcId: String {
        fatalError("Must be overriden")
    }
    
    var storyboardName: String {
        fatalError("Must be overriden")
    }
}

private final class _AnyVCInfoBox<VCI: VCInfo>: _AnyVCInfoBase<VCI.ViewControllerType> {
    private var vcInfo:VCI
    override var vcId: String {
        return vcInfo.vcId
    }
    
    override var storyboardName: String {
        return vcInfo.storyboardName
    }
    
    init(vcInfo: VCI) {
        self.vcInfo = vcInfo
    }
}
