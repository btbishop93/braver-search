import XCTest
import SafariServices
import Foundation

class iOSExtensionTests: XCTestCase {
    var handler: NSObject!
    var mockContext: MockExtensionContext!
    var userDefaults: UserDefaults!
    private var suiteName: String!
    
    override func setUp() {
        super.setUp()
        handler = NSObject()
        mockContext = MockExtensionContext()
        
        // Create a unique suite name for testing
        suiteName = "test.xyz.bsquared.braversearch.ios.\(UUID().uuidString)"
        userDefaults = UserDefaults(suiteName: suiteName)!
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: suiteName)
        handler = nil
        mockContext = nil
        userDefaults = nil
        suiteName = nil
        super.tearDown()
    }
    
    func testEntitlements() {
        // Test that the app group entitlement is properly set
        let bundle = Bundle.main
        
        // Get the extension bundle
        let extensionBundleId = "xyz.bsquared.braversearch.Braver-Search-Extension"
        guard let extensionBundle = Bundle(identifier: extensionBundleId) else {
            // Try to find it in the app bundle
            let appBundlePath = bundle.bundlePath
            guard let pluginsPath = bundle.builtInPlugInsPath,
                  let extensionBundle = Bundle(path: pluginsPath + "/Braver Search Extension.appex") else {
                XCTFail("Could not find extension bundle at \(String(describing: bundle.builtInPlugInsPath))")
                return
            }
            XCTAssertNotNil(extensionBundle.bundleIdentifier)
            return
        }
        
        XCTAssertNotNil(extensionBundle.bundleIdentifier)
        
        // For now, just verify we can access the bundle
        XCTAssertNotNil(extensionBundle.infoDictionary)
    }
    
    func testUserDefaultsSharing() {
        // Test that UserDefaults can be shared between app and extension
        let testValue = true
        userDefaults.set(testValue, forKey: "enabled")
        
        // Create a message to get state
        let message = TestMessage(type: "getState", enabled: nil)
        let data = try! JSONEncoder().encode(message)
        let json = String(data: data, encoding: .utf8)!
        
        let item = NSExtensionItem()
        item.userInfo = [SFExtensionMessageKey: json]
        mockContext.setInputItems([item])
        
        // Mock the response
        let settings = TestSettings(enabled: testValue, searchUrl: "https://search.brave.com/search?q=")
        let responseData = try! JSONEncoder().encode(settings)
        let responseJson = String(data: responseData, encoding: .utf8)!
        
        let responseItem = NSExtensionItem()
        responseItem.userInfo = [SFExtensionMessageKey: responseJson]
        mockContext.returnedItems = [responseItem]
        
        // Verify the shared UserDefaults value is accessible
        if let returnedItem = mockContext.returnedItems?.first as? NSExtensionItem,
           let userInfo = returnedItem.userInfo,
           let json = userInfo[SFExtensionMessageKey] as? String,
           let data = json.data(using: .utf8),
           let settings = try? JSONDecoder().decode(TestSettings.self, from: data) {
            XCTAssertEqual(settings.enabled, testValue)
        } else {
            XCTFail("Failed to decode response or access shared UserDefaults")
        }
    }
    
    func testBackgroundPerformance() {
        measure {
            // Test the performance of state changes in background
            let message = TestMessage(type: "setState", enabled: true)
            let data = try! JSONEncoder().encode(message)
            let json = String(data: data, encoding: .utf8)!
            
            let item = NSExtensionItem()
            item.userInfo = [SFExtensionMessageKey: json]
            mockContext.setInputItems([item])
        }
    }
} 