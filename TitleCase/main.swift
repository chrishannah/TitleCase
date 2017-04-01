//
//  main.swift
//  TitleCase
//
//  Created by Christopher Hannah on 01/04/2017.
//  Copyright © 2017 Christopher Hannah. All rights reserved.
//

import Foundation

func printUsage() {
    print("Usage: title <title>")
    print("")
    print("Example:")
    print("")
    print("    title \"This is the title i want to convert\"")
    print("")
}

func getTitleCase(_ title: String) -> String {
    
    let disallowedCharacters = CharacterSet(charactersIn: "!*'();:@&=$,/\\?%#[]`~\"")
    let spaceSafe = title.replacingOccurrences(of: " ", with: "+")
    let safe = spaceSafe.addingPercentEncoding(withAllowedCharacters: disallowedCharacters.inverted)!
    
    let urlPath = "http://brettterpstra.com/titlecase/?title=\(safe)"
    let url: URL = URL(string: urlPath)!
    let session = URLSession.shared
    
    var title: String = ""
    let semaphore = DispatchSemaphore(value: 0);
    
    let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
        
        if data != nil {
            let string = String(data: data!, encoding: String.Encoding.ascii)
            title = string!
        }
        semaphore.signal()
        
    })
    task.resume()
    
    _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    
    return title
}

let arguments = CommandLine.arguments

if arguments.count == 2 {
    let title = arguments[1]
    print(getTitleCase(title))
} else {
    printUsage()
}
