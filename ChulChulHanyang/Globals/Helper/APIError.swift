//
//  APIError.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/25.
//

import Foundation

enum APIError: Error {
    case failedTogetData
    
}

enum NetworkError: Error {
    case failedToConvertURL
    case serverResponseError(statusCode: Int)
    case failedToLoadHtml
    case failedToParseHtml
}


