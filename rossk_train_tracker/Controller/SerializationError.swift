
enum SerializationError: Error {
    case missingElement(String)
    case invalidResponse(String, Any)
}
