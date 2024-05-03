
import XCTest
@testable import JustRemember

final class JustRememberTests: XCTestCase {
    
    
    func testCollectionListJsonMapping() throws {
        // given
        let vocabularyData : NetworkResponse = Bundle.main.decode("vocabularyData.json")
        let collections: [Collection] = vocabularyData.data
        
        //  then
        XCTAssertNotNil(vocabularyData)
        XCTAssertEqual(collections.count, 7)
        XCTAssertEqual(collections.first?.id, UUID(uuidString: "2428bbb6-5a04-4f89-89f9-96c654fd63d6"))
        XCTAssertEqual(collections.first?.name, "Personality")
        XCTAssertEqual(collections.first?.words.count, 30)
        XCTAssertEqual(collections.first?.words.last?.id, UUID(uuidString: "ffabd303-20ae-4582-974c-c590a7bad1a4" ))
        XCTAssertEqual(collections.first?.words.last?.word, "Bully")
        XCTAssertEqual(collections.first?.words.last?.meaning, "a person who likes to threaten, scare, or hurt others, particularly people who are weaker")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
