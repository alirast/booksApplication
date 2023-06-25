//
//  File.swift
//  
//
//  Created by N S on 24.06.2023.
//

import Vapor
import Fluent

//model is a protocol of vapor for working with data models from data base
final class Book: Model {
    
    //schema is a table where we will have books
    //address of our table in data base where we have books
    static var schema: String = "books"
    
    //property wrapper
    //uuid is unique identifier that is generated from different parameters
    @ID var id: UUID?
    
    //also property wrapper
    //property wrapper with the key title
    @Field(key: "title")
    var title: String
    
    @Field(key: "author")
    var author: String
    
    @Field(key: "year")
    var year: Int
    
    //required
    init() { }
    
    //for us - convenient
    init(id: UUID? = nil, title: String, author: String, year: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.year = year
    }
    
}

//confirm protocol content to transfer our book from decodable model to json and from json to model (migration)
extension Book: Content {
    
}

//if need optional property - all the same just through @OptionalField
//@OptionalField(key: "")
