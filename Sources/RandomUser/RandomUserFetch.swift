//
//  RandomUserFetch.swift
//  
//
//  Created by Kevin Wooten on 8/18/20.
//

import Foundation
import Combine

public struct RandomUserFetch<T> {

  public enum Field: String {
    case gender
    case name
    case location
    case email
    case login
    case registered
    case dob
    case phone
    case cell
    case id
    case picture
    case nat
  }
  
  public enum Nationality: String {
    case au = "AU"
    case br = "BR"
    case ca = "CA"
    case ch = "CH"
    case de = "DE"
    case dk = "DK"
    case es = "ES"
    case fi = "FI"
    case fr = "FR"
    case gb = "GB"
    case ie = "IE"
    case ir = "IR"
    case no = "NO"
    case nl = "NL"
    case nz = "NZ"
    case tr = "TR"
    case us = "US"
  }
  
  public let seed: String?
  public let include: [Field]?
  public let exclude: [Field]?
  public let nationalities: [Nationality]?
  public let gender: RandomUserData.Gender?
  public let debug: Bool
  
  public init(seed: String? = nil, include: [Field]? = nil, exclude: [Field]? = nil, nationalities: [Nationality]? = nil, gender: RandomUserData.Gender? = nil, debug: Bool = false) {
    self.seed = seed
    self.include = include
    self.exclude = exclude
    self.nationalities = nationalities
    self.gender = gender
    self.debug = debug
  }

  public func execute(page: Int? = nil, count: Int? = nil, transform: @escaping (RandomUserData, RandomUserResults.Info) throws -> T) -> AnyPublisher<[Result<T, Error>], Error> {
    
    guard var urlBuilder = URLComponents(string: "https://randomuser.me/api/1.3/") else { fatalError("invalid url") }

    var queryItems = [URLQueryItem]()
        
    if let page = page {
      queryItems.append(.init(name: "page", value: "\(page)"))
    }

    if let count = count {
      queryItems.append(.init(name: "results", value: "\(count)"))
    }
    
    if let seed = seed {
      queryItems.append(.init(name: "seed", value: "\(seed)"))
    }
    
    if let include = include {
      queryItems.append(.init(name: "inc", value: include.map { "\($0)" }.joined(separator: ",")))
    }
    
    if let exclude = exclude {
      queryItems.append(.init(name: "exc", value: exclude.map { "\($0)" }.joined(separator: ",")))
    }
    
    if let nationalities = nationalities {
      queryItems.append(.init(name: "nat", value: nationalities.map { "\($0)" }.joined(separator: ",")))
    }
    
    if let gender = gender {
      queryItems.append(.init(name: "gender", value: "\(gender)"))
    }
    
    urlBuilder.queryItems = queryItems
    
    guard let url = urlBuilder.url else { fatalError("invalid url") }
    
    if debug {
      print("Fetching: ", url)
    }

    return urlSession.dataTaskPublisher(for: url)
      .map { $0.data }
      .handleEvents(receiveOutput: { data in
        if debug {
          print(String(data: data, encoding: .utf8)!)
        }
      })
      .decode(type: RandomUserResults.self, decoder: jsonDecoder)
      .map { (results: RandomUserResults) -> [Result<T, Error>] in
        results.results.map { userData -> Result<T, Error> in
          do {
            return .success(try transform(userData, results.info))
          }
          catch {
            return .failure(error)
          }
        }
      }
      .eraseToAnyPublisher()
  }

}

extension RandomUserFetch where T == RandomUserData {
  
  public func execute(page: Int? = nil, count: Int? = nil) -> AnyPublisher<[Result<T, Error>], Error> {
    return execute(page: page, count: count) { data, _ in data }
  }
  
}

let urlSession = URLSession(configuration: .default)
let jsonDecoder: JSONDecoder = {
  let df = ISO8601DateFormatter()
  df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
  
  let d = JSONDecoder()
  d.dateDecodingStrategy = .custom({ decoder -> Date in
    guard let date = df.date(from: try decoder.singleValueContainer().decode(String.self)) else {
      fatalError("invalid date")
    }
    return date
  })
  return d
}()
