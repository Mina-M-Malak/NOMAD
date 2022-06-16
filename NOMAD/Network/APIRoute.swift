//
//  APIRoute.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/16/22.
//

import Foundation

class APIRoute {
    // Our singletone
    static let shared:APIRoute = APIRoute()
    private var timer:Timer?
    private var sessionTask:URLSessionDataTask?
    private init(){}
    
    private func initRequest(_ clientRequest:NOMAD)->URLRequest {
        var request:URLRequest = clientRequest.request
        
        request.httpMethod = clientRequest.method.rawValue
        if let body = clientRequest.body{
            let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        request.addHeaders(clientRequest.headers)
        //        print("clientRequest.path==\(clientRequest.path)",Date())
        
        if sessionTask != nil && clientRequest.Cancellable {
            if (sessionTask?.originalRequest?.url?.absoluteString.contains(clientRequest.path) ?? false) {
                //                print ("Canceled \(sessionTask?.originalRequest?.url?.absoluteString) with \(clientRequest.request.url?.absoluteString),clientRequest.path\(clientRequest.path) ")
                sessionTask?.cancel()
                sessionTask?.suspend()
            }
        }
        return request
    }
    
    private func JSONTask<T:Decodable>(with request: URLRequest, decodingModel: T.Type, completion: @escaping (Result<T, APIError>)-> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                //                print("RequestTimeOut)")
                return
            }
            //            print("request url:\(String(describing: request.url)) with status code \(httpResponse.statusCode)")
            switch httpResponse.statusCode {
            case 200...204:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                var responseModel:T!
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard JSONSerialization.isValidJSONObject(json) else {
                        completion(.failure(.invalidData))
                        return
                    }
                    responseModel = try JSONDecoder().decode(T.self, from: data)
                } catch let err {
                    print("request url:\(String(describing: request.url)) with serialization error \(err)")
                    
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                completion(.success(responseModel))
            case 400...504:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                var responseModel:GeneralErrorMessage!
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard JSONSerialization.isValidJSONObject(json) else {
                        completion(.failure(.invalidData))
                        return
                    }
                    responseModel = try JSONDecoder().decode(GeneralErrorMessage.self, from: data)
                } catch let err {
                    print("request url:\(String(describing: request.url)) with serialization error \(err)")
                    
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                completion(.failure(.message(value: responseModel)))
            default:
                completion(.failure(.responseUnsuccessful))
            }
        }
        return task
    }
    
    func fetch<T: Decodable>(has loading:Bool = true, with clientRequest: NOMAD, model: T.Type,qos:DispatchQoS.QoSClass = .default, completion: ((Result<T, APIError>)->())?) {
        
        //        DispatchQueue.global(qos: .background).async {
        if loading {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showspinner), userInfo: nil, repeats: false)
        }
        let request:URLRequest = self.initRequest(clientRequest)
        self.sessionTask = self.JSONTask(with: request, decodingModel: model.self) {[weak self] (result) in
            self?.timer?.invalidate()
            self?.timer = nil
            guard let self = self else { return }
            guard let sessionTask = self.sessionTask else { return }
            guard let response = self.handleResponse(sessionTask, result) else {
                //                print("Error accured with the response")
                return
            }
            
            DispatchQueue.main.async {
                completion?(response)
            }
            //                if qos == .default {
            //                    DispatchQueue.main.async {
            //                        completion?(response)
            //                    }
            //                } else {
            //                    DispatchQueue.global(qos: qos).async {
            //                        completion?(response)
            //                    }
            //                }
        }
        self.sessionTask?.resume()
        
        //        }
        
    }
    
    @objc func showspinner(){
        //        Helper.showSpinner()
    }
    
    private func handleResponse<T: Decodable>(_ task:URLSessionTask, _ response: Result<T,APIError>)->Result<T,APIError>? {
        //        print("request== \(task.state.rawValue)")
        return response
    }
}
