//
//  File.swift
//  
//
//  Created by N S on 25.06.2023.
//

import Fluent

//for transering data from data base to swift model and reverse
struct CreateBook: Migration {

    //preparation for data base
    //event loop future
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("year", .int, .required)
            .create()
    }
    
    //deletion from data base of our table is there is nothing in data base
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("books").delete()
    }
    
}
