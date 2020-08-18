import XCTest
@testable import RandomUser

final class RandomUserTests: XCTestCase {
  
  func testExecuteWithDefaultOptions() throws {
    
    let resultsX = expectation(description: "Results")
    
    let fetch = RandomUserFetch<RandomUserData>(debug: true)
    
    let fetchCancel = fetch.execute(page: 0, count: 100)
      .sink { completion in
        if case .failure(let error) = completion {
          XCTFail("Fetch failed: \(error.localizedDescription)")
        }
        resultsX.fulfill()
      } receiveValue: { userData in
        userData.forEach {
          switch $0 {
          case .success(let data):
            print(data)
          case .failure(let error):
            print(error)
          }
        }
      }
    
    waitForExpectations(timeout: 5)
    
    fetchCancel.cancel()
  }
  
  func testExecuteWithAllOptions() throws {
    
    let resultsX = expectation(description: "Results")
    
    let fetch = RandomUserFetch<RandomUserData>(seed: "8912743", include: [.gender, .name], exclude: [.location], nationalities: [.us, .au], gender: .female, debug: true)
    
    let fetchCancel = fetch.execute(page: 0, count: 100)
      .sink { completion in
        if case .failure(let error) = completion {
          XCTFail("Fetch failed: \(error.localizedDescription)")
        }
        resultsX.fulfill()
      } receiveValue: { userData in
        userData.forEach {
          switch $0 {
          case .success(let data):
            print(data)
          case .failure(let error):
            print(error)
          }
        }
      }
    
    waitForExpectations(timeout: 5)
    
    fetchCancel.cancel()
  }

  static var allTests = [
    ("testExecuteWithDefaultOptions", testExecuteWithDefaultOptions),
    ("testExecuteWithAllOptions", testExecuteWithAllOptions),
  ]
  
}
