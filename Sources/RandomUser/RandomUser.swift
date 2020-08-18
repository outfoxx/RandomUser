//
//  RandomUserData.swift
//
//
//  Created by Kevin Wooten on 8/18/20.
//

import Foundation

public struct RandomUserData : Codable {
  
  public enum Gender : String, Codable {
    case male
    case female
  }
  
  public let gender: String?
  
  public struct Name : Codable {
    public let title: String
    public let first: String
    public let last: String
  }
  
  public let name: Name?
  
  public struct Location : Codable {
    
    public struct Street : Codable {
      public let number: Int
      public let name: String
    }
    
    public let street: Street
    public let city: String
    public let state: String
    public let country: String
    
    public struct Postcode : Codable {
      public let number: Int?
      public let string: String?

      public init(from decoder: Decoder) {
        do {
          self.number = try decoder.singleValueContainer().decode(Int.self)
        }
        catch {
          self.number = nil
        }
        do {
          self.string = try decoder.singleValueContainer().decode(String.self)
        }
        catch {
          self.string = nil
        }
      }
    }
    
    public let postcode: Postcode
    
    public struct Coordinates : Codable {
      public let latitude: String
      public let longitude: String
    }
    
    public let coordinates: Coordinates
    
    public struct Timezone : Codable {
      public let offset: String
      public let description: String
    }
    
    public let timezone: Timezone
  }
  
  public let location: Location?
  
  public let email: String?
  
  public struct Login : Codable {
    public let uuid: String
    public let username: String
    public let password: String
    public let salt: String
    public let md5: String
    public let sha1: String
    public let sha256: String
  }
  
  public let login: Login?
  
  public struct DOB : Codable {
    public let date: Date
    public let age: Int
  }
  
  public let dob: DOB?
  
  public struct Registered : Codable {
    public let date: Date
    public let age: Int
  }
  
  public let registered: Registered?
  
  public let phone: String?
  
  public let cell: String?
  
  public struct Id : Codable {
    public let name: String
    public let value: String?
  }
  
  public let id: Id?
  
  public struct Picture : Codable {
    public let large: String
    public let medium: String
    public let thumbnail: String
  }
  
  public let picture: Picture?
  
  public let nat: String?
}
