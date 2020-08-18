//
//  RandomUserResults.swift
//  
//
//  Created by Kevin Wooten on 8/18/20.
//

import Foundation

public struct RandomUserResults : Codable {
  
  public struct Info : Codable {
    public let seed: String
    public let results: Int
    public let page: Int
    public let version: String
  }
  
  public let info: Info
  public let results: [RandomUserData]
  
}
