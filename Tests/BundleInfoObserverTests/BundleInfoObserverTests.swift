import XCTest
@testable import BundleInfoObserver

final class BundleInfoObserverTests: XCTestCase {
    
    
    func test_init_bundle() {
        
        //arrange
        let bundle = FakeBundle()
        
        //act
        let sut = BundleInfoObserver(bundle: bundle)
        
        //assert
        XCTAssertEqual(sut.bundle, bundle)
    }
    
    func test_observerChange_oldValue_isNil() {
        
        //arrange
        let storage = FakeStorage()
        let bundle = FakeBundle()
        bundle.fakeInfoDictionary = ["key": "value"]
        
        let sut = BundleInfoObserver(bundle: bundle, storage: storage)
        
        //act
        var expected: String?
        sut.observerChange(forKeyPath: "keypath") { (oldValue: String?, _) in
            expected = oldValue
        }
        
        //Assert
        XCTAssertNil(expected)
    }
    
    func test_observerChange_newValue_isReadFromInfoDictionary() {
        
        //arrange
        let storage = FakeStorage()
        let bundle = FakeBundle()
        bundle.fakeInfoDictionary = ["key": "value"]
        let sut = BundleInfoObserver(bundle: bundle, storage: storage)
        
        //act
        var expected: String?
        sut.observerChange(forKeyPath: "key") { (_, newValue) in
            expected = newValue
        }
        
        //assert
        XCTAssertEqual(expected, "value")
    }
    
    func test_observerChange_oldValue_afterReceivingNewValue_isEqualToNewValue() {
        
        //arrange
        let storage = FakeStorage()
        let bundle = FakeBundle()
        bundle.fakeInfoDictionary = ["key": "value"]
        
        let sut = BundleInfoObserver(bundle: bundle, storage: storage)
        
        //act
        sut.observerChange(forKeyPath: "key") { (_: String?, _: String?) in }
        
        //assert
        XCTAssertEqual(storage.getValue(for: "key"), "value")
    }
    
    func test_observerChange_oldValueisNotSavedTwiceafterReceivingNewValue_WhenEqualToNewValue() {
        
        //arrange
        let storage = FakeStorage()
        let bundle = FakeBundle()
        bundle.fakeInfoDictionary = ["key": "value"]
        
        let sut = BundleInfoObserver(bundle: bundle, storage: storage)
        sut.observerChange(forKeyPath: "key") { (_: String?, _: String?) in }
        
        //act
        sut.observerChange(forKeyPath: "key") { (_: String?, _: String?) in
            
            //assert
            XCTFail()
        }
    }
    
    func test_observerChange_newValue_isReadFromEmbeddedInfoDictionary() {
        
        //arrange
        let storage = FakeStorage()
        let bundle = FakeBundle()
        bundle.fakeInfoDictionary = ["key": ["path": "value"]]
        let sut = BundleInfoObserver(bundle: bundle, storage: storage)
        
        //act
        var expected: String?
        sut.observerChange(forKeyPath: "key/path") { (_, newValue) in
            expected = newValue
        }
        
        //Assert
        XCTAssertEqual(expected, "value")
    }

    static var allTests = [
        ("testExample", test_init_bundle),
    ]
}