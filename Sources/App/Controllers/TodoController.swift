import Vapor
import SwiftSoup

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
     
    func getPrice(_ req: Request) throws -> String {
        
        let myURLString = "https://www.clever-tanken.de/tankstelle_details/10788"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }
        
        do {
            let html = try String(contentsOf: myURL, encoding: .ascii)
            let doc: Document = try SwiftSoup.parse(html)
            let elements = try doc.select(".price-field")
            let text = try elements.first()?.text().replacingOccurrences(of: " ", with: "")
            
            return text ?? ""
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
        
        return ""
    }
}
