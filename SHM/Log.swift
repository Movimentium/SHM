//
//  Log.swift
//  SHM
//
//  Created by Miguel on 29/09/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

// Stringnable:
/// protocol with the definition of the description method
// The extension of Stringnable protocol:
/// give a default implementation of description method used to log in console info about objects

public protocol Stringnable {
     var strDescr: String { get }
}

extension Stringnable {
    public var strDescr: String {
        let mirror = Mirror(reflecting: self)
        let strType = "\(mirror.subjectType)"
        var str = "> > \(strType):\n"     // To provide better visibility and object diferentation in XCode console
        for _ in 0...(strType.count + 5) {
            str += "-"
        }
        str += "\n"
        for (k, v) in mirror.children {
            var strValue = ""
            if let str = v as? String {
                strValue = str
            }
            else if let n = v as? Int {
                strValue = String(n)
            }
            else if let b = v as? Bool {
                strValue = (b ? "true" : "false" )
            }
            else if let f = v as? Float {
                strValue = f.description
            }
            else if let d = v as? Double {
                strValue = d.description
            }
            else if let arr = v as? [Any?] {
                for obj in arr  {
                    if let o = obj as? Stringnable {
                        strValue += "\n\n"
                        strValue += o.strDescr
                    }
                }
            }
            else if let o = v as? Stringnable {
                strValue = o.strDescr
            }
            else {
                strValue = "---"
            }
            str.append("\(k ?? "---"): \(strValue)\n")
        }
        return str
    }
}

class Log {
    
    private static let isLogOn = true
    //    private static let isLogOn = false
    
    private static let strNil = "---"

    class func obj(_ obj:Any?) {
        if isLogOn {
            print(Log.description(of: obj))
        }
    }
    
    class func description(of obj:Any?) -> String {
        if let o = obj as? Stringnable {
            return o.strDescr
        }
        return "Error: obj is not Stringnable"
    }
    
    class func printDescr(of obj:Any?){
        print(Log.description(of: obj))
    }
    
    class func request(_ request: URLRequest){
        
        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"
        
        var s = "\n>>-------- REQUEST --------->>\n"
        s += "\(urlString)"
        s += "\n\n"
        s += "\(method) \(path)?\(query) HTTP/1.1\n"
        s += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            s += "\(key): \(value)\n"
        }
        if let body = request.httpBody {
            s += self.dataToPrettyStrJson(data: body)
        }
        s += "\n>>-------------------------->>\n";
        print(s)
    }
    
    class func response(data: Data?, response: HTTPURLResponse?, error: Error?){
        
        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        
        var s = "\n<<--------- RESPONSE --------<<\n"
        if let urlString = urlString {
            s += "\(urlString)"
            s += "\n\n"
        }
        
        if let statusCode =  response?.statusCode{
            s += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            s += "Host: \(host)\n"
        }
        for (key,value) in response?.allHeaderFields ?? [:] {
            s += "\(key): \(value)\n"
        }
        if let body = data{
            s += self.dataToPrettyStrJson(data: body)
        }
        if error != nil{
            s += "\nError: \(error!.localizedDescription)\n"
        }
        s += "\n<<---------------------------<<\n";
        print(s)
        
    }
    
    class func dataToPrettyStrJson(data: Data) -> String {
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)
            if let string = String(data: jsonData, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        return ""
    }
}
