# NetworkKit
A generic project to manage network requests

## HTTP request
In this kit, an HTTP request comprises four elements:

- **Creator**: Protocol `RequestURL` for creating the URL.
- **Type**: Protocol `HTTPMethod` for specifying the HTTP method.
- **Header**: Protocol `RequestHeader` for modifying headers.
- **Body**: Protocol `RequestBody` for defining the request body.


This kit provides two `URLRequest` initializers:
- `init<T>(_ requestService: T) throws where T: URLRequestService`
    - `typealias URLRequestService = RequestURL & RequestHeader & HTTPMethod`
- `init<T, B>(_ requestService: T, bodyValue: B) throws where T: URLRequestService, B: RequestBody`


Check section below for use cases.

## URL Session
This kit manages the `URLSessionConfiguration` internally with an actor called `URLSessionManager`.
And the actor `URLSessionManager` is managed by the services below:

- **Service**: Manages sessions by resuming a `URLSession.data(for:delegate)`.
- **ServiceTask**: Creates and manages a `URLSessionTask`, allowing requests to be cancelled.


Is up to the user to use the `Service` or `ServiceTask` actors with a `URLRequest` or
extend them with functions that make use of the `URLRequest` custom initializers
described in the previous section together with models that define the structures
of the responded data and also conforms with the protocols described in the previous
section. See example below:

```Swift
extension URLRequest {
    struct SignUp: Codable {
        let env: String
    }
}
extension URLRequest.SignUp: RequestURL {
    var url: String { "www.myServer.com/v2/\(env)/signup" }
}
extension URLRequest.SignUp: HTTPMethod {
    var httpMethod: HTTMethodValue { .get }
}
extension RequestHeader {
    func modifierDefault(_ request: URLRequest) -> URLRequest {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
extension URLRequest.SignUp: RequestHeader {
    func modifierHeader(_ request: URLRequest) -> URLRequest {
        modifierDefault(request)
    }
}
// RequestBody protocol includes a default modifierBody function which just
// serialized the struct conforming with `RequestBody` and set it to
// the `URLRequest.httpBody` property, so is enought with just conform with it/
extension URLRequest.SignUp {
    struct Body: RequestBody {
        let email: String
        let password: String
        init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
}
// Some servers are implemented in a way where the data returned may have
// two possible structures, the data model expected or a data that represents
// the error encounter during the processing of the request. When this error data
// model is defined ahead, we can handle it before the expected model is created
// and in this way differentiate between a error data model vs bad formatted data model.
extension URLRequest {
    struct DataError: Decodable & Error {
        var code: String
        let message: String
    }
}
extension Service {
    func signUp(email: String, password: String) async throws -> URLRequest.SignUp {
        let env = "prod" // Use some Dependency Injection instead
        let signUp = URLRequest.SignUp(env:env)
        let bodyObject = URLRequest.SignUp.Body(email: email,
                                                         password: password)
        let request = try URLRequest(signUp, bodyValue: bodyObject)
        let (data, _) = try await self.callService(request,
                                                   withCache: false,
                                                   errorProcessorType: URLRequest.DataError.self)
        return try JSONDecoder().decode(URLRequest.SignUp.self, from: data)
    }
}

```    



## Configuration
Currently is supported two configurations, with or without memory cache.
The second configuration relaies on existing App Cache configuration.
If the cache memory was set, it will be used, otherwise it will silenty not be
relevant during the HTTP calls.








