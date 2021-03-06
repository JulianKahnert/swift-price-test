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
    
    func getPriceDelay(_ req: Request) throws -> String {
        
        // delay the request
        sleep(5)
        
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
    
    
    func getWikidata(_ req: Request) throws -> String {
        
        let encodedQuery = "SELECT%20%3FNintendo_Entertainment_System%20%3FNintendo_Entertainment_SystemLabel%20WHERE%20%7B%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22%5BAUTO_LANGUAGE%5D%2Cen%22.%20%7D%0A%20%20%3FNintendo_Entertainment_System%20wdt%3AP400%20wd%3AQ172742.%0A%7D%0ALIMIT%201000"
        guard let url = URL(string: "https://query.wikidata.org/sparql?query=\(encodedQuery)&format=text/tab-separated-values") else { return "ERROR" }
        
        let content = try? String(contentsOf: url)
//        print(content)
        
//        var request = URLRequest(url: url)
//        request.setValue("Accept", forHTTPHeaderField: "application/json")
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//
//            print(response)
////
////            print("#####################################################")
//            print(data)
//
//            semaphore.signal()
//        }.resume()
//
//        semaphore.wait(timeout: .now() + 5)
        
        
        return content ?? "ERROR"
    }
}
