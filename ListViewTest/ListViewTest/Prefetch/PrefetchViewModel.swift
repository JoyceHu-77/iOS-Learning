//
//  PrefetchViewModel.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/8.
//

import Foundation
import UIKit

class PrefetchViewModel {
    /// 已下载过，有缓存
    private var cachedImage: UIImage?
    /// 下载到一半
    private var isDownloading = false
    private var downloadingCallBack: ((UIImage?) -> Void)?
    
    func downloadImage(completion: ((UIImage?) -> Void)?) {
        if let cachedImage = cachedImage {
            completion?(cachedImage)
            return
        }
        
        if isDownloading {
            downloadingCallBack = completion
            return
        }
        isDownloading = true
        
        let size = Int.random(in: 100...350)
        
        guard let url = URL(string: "https://source.unsplash.com/random/\(size)x\(size)") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.cachedImage = image
                self?.downloadingCallBack?(image)
                self?.downloadingCallBack = nil
                completion?(image)
            }
        }
        task.resume()
    }
}
