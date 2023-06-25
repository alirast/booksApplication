//
//  File.swift
//  
//
//  Created by N S on 25.06.2023.
//

import Vapor
import Fluent

struct BooksController: RouteCollection {
    
    //to call the operations with routes
    func boot(routes: Vapor.RoutesBuilder) throws {
        let booksRoutes = routes.grouped("api", "books")
        booksRoutes.get(use: getAllHandler)
        booksRoutes.get(":bookID", use: getHandler)
        booksRoutes.post(use: createHandler)
        booksRoutes.put(":bookID", use: updateHandler)
        booksRoutes.delete(":bookID", use: deleteHandler)
    }
    
    //handlers of routes
    //get all books
    func getAllHandler(_ request: Request) -> EventLoopFuture<[Book]> {
        Book.query(on: request.db).all()
    }
    
    //get one special book
    func getHandler(_ request: Request) -> EventLoopFuture<Book> {
        Book.find(request.parameters.get("bookID"), on: request.db)
            .unwrap(or: Abort(.notFound))
    }
    
    //get book
    func createHandler(_ request: Request) throws -> EventLoopFuture<Book> {
        let book = try request.content.decode(Book.self)
        return book.save(on: request.db).map({ book })
    }
    
    //update book
    func updateHandler( _ request: Request) throws -> EventLoopFuture<Book> {
        //from the content of request we got a json to decode it as a book
        let updatedBook = try request.content.decode(Book.self)
        //the book we will update
        let book = Book.find(request.parameters.get("bookID"), on: request.db)
            .unwrap(or: Abort(.notFound)).flatMap { book in
                book.title = updatedBook.title
                book.author = updatedBook.author
                book.year = updatedBook.year
                return book.save(on: request.db).map({ book })
            }
        return book
    }
    
    //delete book
    func deleteHandler(_ request: Request) -> EventLoopFuture<HTTPStatus> {
        Book.find(request.parameters.get("bookID"), on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                book.delete(on: request.db)
                    .transform(to: .noContent)
            }
    }
    
    
}
