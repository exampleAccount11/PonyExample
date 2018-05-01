
public struct Parameters {
    
    public let header: [Parameter]
    public let path: [Parameter]
    public let query: [Parameter]
    public let body: [Parameter]
    
    public init(header: [Parameter] = [], path: [Parameter] = [], query: [Parameter] = [], body: [Parameter] = []) {
        self.header = header
        self.path = path
        self.query = query
        self.body = body
    }
}

