import Fluent
import Vapor

func routes(_ app: Application) throws {
    let booksController = BooksController()
    try app.register(collection: booksController)
}
