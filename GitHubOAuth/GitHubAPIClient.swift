//
//  GitHubAPIClient.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/31/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class GitHubAPIClient {
    
    // MARK: Path Router
    enum URLRouter {
        static let repo = ""
        static let token = ""
        static let oauth = ""
        
        static func starred(repoName repo: String) -> String? {return nil}
    }

}

// MARK: Repositories
extension GitHubAPIClient {
    
    class func getRepositoriesWithCompletion(completionHandler: (JSON?) -> Void) {
        
        Alamofire.request(.GET, URLRouter.repo)
            .validate()
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    if let data = response.data {
                        completionHandler(JSON(data: data))
                    }
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(nil)
                }
            })
        
    }
    
}


// MARK: OAuth
extension GitHubAPIClient {
    
    
    class func hasToken() -> Bool {
        
        return false
    }
    
}


// MARK: Activity
extension GitHubAPIClient {
    
    class func checkIfRepositoryIsStarred(fullName: String, completionHandler: (Bool?) -> ()) {
        
        guard let urlString = URLRouter.starred(repoName: fullName) else {
            print("ERROR: Unable to get url path for starred status")
            completionHandler(nil)
            return
        }
        
        Alamofire.request(.GET, urlString)
            .validate(statusCode: 204...404)
            .responseString(completionHandler: { response in
                switch response.result {
                case .Success:
                    if response.response?.statusCode == 204 {
                        completionHandler(true)
                    } else if response.response?.statusCode == 404 {
                        completionHandler(false)
                    }
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(nil)
                }
                
                
            })
        
    }
    
    class func starRepository(fullName: String, completionHandler: (Bool) -> ()) {
        
        guard let urlString = URLRouter.starred(repoName: fullName) else {
            print("ERROR: Unable to get url path for starred status")
            completionHandler(false)
            return
        }
        
        Alamofire.request(.PUT, urlString)
            .validate(statusCode: 204...204)
            .responseString(completionHandler: { response in
                switch response.result {
                case .Success:
                    completionHandler(true)
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(false)
                }
            })
        
    }
    
    class func unStarRepository(fullName: String, completionHandler: (Bool) -> ()) {
        
        guard let urlString = URLRouter.starred(repoName: fullName) else {
            print("ERROR: Unable to get url path for starred status")
            completionHandler(false)
            return
        }
        
        Alamofire.request(.DELETE, urlString)
            .validate(statusCode: 204...204)
            .responseString(completionHandler: { response in
                switch response.result {
                case .Success:
                    completionHandler(true)
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(false)
                }
            })
        
    }
    
}

