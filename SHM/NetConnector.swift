//
//  NetConnector.swift
//  SHM
//
//  Created by Miguel on 29/09/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit

class NetConnector {

    static let single = NetConnector()
    private init() {}
    
    var session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: nil)
    
    let strEndpoint = "http://gateway.marvel.com/v1/public/"
    private let ts = 1 // param ts - a timestamp (or other long string which can change on a request-by-request basis)
    private let apiKey = "47997bf10347e417676f096871a3ff63"  // apikey param - public key
    private let strHash = "106c34b206ff1addf1752ca99e1dc5d7" //param hash - a md5 digest of the ts parameter, your private key and your public key (e.g. md5(ts+privateKey+publicKey)
    lazy private(set) var authParams: String = {
        var str = "?"
        str += "ts=\(self.ts)"
        str += "&apikey=\(self.apiKey)"
        str += "&hash=\(self.strHash)"
        return str
    }()
    
   
    private let cacheForThumbnails = NSCache<NSString, UIImage>()

    func thumbnail(path: String, ext: String) -> UIImage? {
        let nsStrPath = path as NSString
        var img: UIImage? = nil  // or default thumbnail
        if let cachedImg = cacheForThumbnails.object(forKey: nsStrPath) {
            img = cachedImg
        } else if let urlThumbnail = URL(string: path + ext){
            session.dataTask(with: urlThumbnail) { (data, resonse, error) in
                guard let _ = error, let imgData = data, let imgDownloaded = UIImage(data: imgData) else {
                    return
                }
                DispatchQueue.main.async {
                    img = imgDownloaded
                    self.cacheForThumbnails.setObject(imgDownloaded, forKey: nsStrPath )
                }
            }
        }
        return img
    }
}

//For example, a user with a public key of "1234" and a private key of "abcd" could construct a valid call as follows:
//http://gateway.marvel.com/v1/public/comics?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150
//(the hash value is the md5 digest of 1abcd1234)

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetRequest {
    case characters
    // TODO: write rest of requests
    // case globalPosition
    // . . .
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .characters:  return .get
        }
    }
    
    private var strEndPoint: String {
        let netCon = NetConnector.single
        switch self {
        case .characters:
            return netCon.strEndpoint + "characters" + netCon.authParams
        }
    }
    
    private var headers: [String : String]? {
        switch self {
        case .characters:  return nil
        }
    }

    private var body: [String : Any]? {
        switch self {
        case .characters:  return nil
        }
    }

    private func newRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: self.strEndPoint)!)
        request.timeoutInterval = 5  // default 60
        //request.setValue("", forHTTPHeaderField: "Accept-Language")
        request.httpMethod = self.httpMethod.rawValue
        for (k,v) in (self.headers ?? [:]) {
            request.setValue(v, forHTTPHeaderField: k)
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = self.body {
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        } else {
            request.httpBody = "".data(using: .utf8)
        }
        return request
    }
    
    func resumeTask(completion: @escaping (_ success:Bool,_ errorMsg: String?,_ data:Data?) -> Void) {
        let task = NetConnector.single.session.dataTask(with: newRequest()) { (dataResp:Data?, urlResp:URLResponse?, error:Error?) in
            guard let data = dataResp else {
                print("ERROR: responseData == nil")  
                completion(false,nil,nil)
                return
            }
            let httpUrlResp = urlResp as! HTTPURLResponse
            print(data)
            Log.response(data: data, response: httpUrlResp, error: error)
            
            if httpUrlResp.statusCode == 200 {
                do {
                    SHMDataProvider.single.response = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    Log.printDescr(of: SHMDataProvider.single.response)
                    completion(true, nil, data)
                } catch  {
                    print(error.localizedDescription)
                    completion(false, error.localizedDescription, nil)
                }
            }
            else {
                // TODO: write code for others statusCode: 404, 401, ...
                completion(false, "ERROR: statusCode != 200", nil)
            }
        }
        task.resume()
    }
}


// MARK: - API docs
// https://developer.marvel.com/documentation/authorization
// https://developer.marvel.com/docs#!/public/getCharacterIndividual_get_1
// Authorization Errors
//The following errors are returned by the Marvel Comics API when issues with authorization occur. These errors are returned by all endpoints.
//
//Error Code    Error Message    Reason for occurring
//409    Missing API Key    Occurs when the apikey parameter is not included with a request.
//409    Missing Hash    Occurs when an apikey parameter is included with a request, a ts parameter is present, but no hash parameter is sent. Occurs on server-side applications only.
//409    Missing Timestamp    Occurs when an apikey parameter is included with a request, a hash parameter is present, but no ts parameter is sent. Occurs on server-side applications only.
//401    Invalid Referer    Occurs when a referrer which is not valid for the passed apikey parameter is sent.
//401    Invalid Hash    Occurs when a ts, hash and apikey parameter are sent but the hash is not valid per the above hash generation rule.
//405    Method Not Allowed    Occurs when an API endpoint is accessed using an HTTP verb which is not allowed for that endpoint.
//403    Forbidden    Occurs when a user with an otherwise authenticated request attempts to access an endpoint to which they do not have access.
