//
//  APICaller.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/7.
//

import Foundation

class APICaller {
    var isPagination = false
    func fetchData(pagination: Bool = false, completion: @escaping (Result<[String], Error>) -> Void) {
        if pagination {
            isPagination = true
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 2 : 0)) {
            let originalData = [
                "aaaa",
                "bbbb",
                "cccc",
                "dddd",
                "aaaa",
                "bbbb",
                "cccc",
                "dddd",
                "aaaa",
                "bbbb",
                "cccc",
                "dddd",
            ]
            
            let newData = [
                "1111",
                "2222",
                "3333",
                "4444"
            ]
            completion(.success(pagination ? newData : originalData))
            if pagination {
                self.isPagination = false
            }
        }
    }
}
