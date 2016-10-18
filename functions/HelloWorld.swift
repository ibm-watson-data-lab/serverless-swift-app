func main(args: [String:Any]) -> [String:Any] {
    if let message = args["message"] as? String {
        return ["reply": "Hello \(message)!"]
    }
    else {
        return ["reply": "Hello stranger!"]
    }
}