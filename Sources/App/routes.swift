import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    //add new route for putting our book to data base (create - crud)
    app.post("api", "books") { request -> EventLoopFuture<Book> in
        //decoding the book we got in the body of the request
        let book = try request.content.decode(Book.self)
        
        //saving book to data base
        return book.save(on: request.db).map({ book })
    }
    
    //to get a book (retrieve - crud)
    app.get("api", "books") { request -> EventLoopFuture<[Book]> in
        Book.query(on: request.db).all()
    }
    
    
    //to get one special book (crud - retrieve about one special id)
    app.get("api", "books", ":bookID") { request -> EventLoopFuture<Book> in
        Book.find(request.parameters.get("bookID"), on: request.db)
            .unwrap(or: Abort(.notFound))
    }

    //(crud - update)
    //cannot change all the books, just one - according to its id
    app.put("api", "books", ":bookID") { request -> EventLoopFuture<Book> in
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
    
    //(crud - delete a book according to its id)
    app.delete("api", "books", ":bookID") { request -> EventLoopFuture<HTTPStatus> in
        Book.find(request.parameters.get("bookID"), on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                book.delete(on: request.db)
                    .transform(to: .noContent)
            }
    }
}
