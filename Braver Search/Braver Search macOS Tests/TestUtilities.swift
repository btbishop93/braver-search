import Foundation

// Mock NSExtensionContext for testing
class MockExtensionContext: NSExtensionContext {
    private var _inputItems: [Any] = []
    var returnedItems: [Any]?
    var completeRequestCallCount = 0
    
    override var inputItems: [Any] {
        return _inputItems
    }
    
    func setInputItems(_ items: [NSExtensionItem]) {
        _inputItems = items
    }
    
    override func completeRequest(returningItems items: [Any]?, completionHandler: ((Bool) -> Void)?) {
        completeRequestCallCount += 1
        returnedItems = items
        completionHandler?(true)
    }
} 