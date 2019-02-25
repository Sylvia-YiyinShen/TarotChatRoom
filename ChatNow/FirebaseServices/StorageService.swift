//
//  StorageService.swift
//  ChatNow
//
//  Created by Zhihui Sun on 25/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    private let storeRef: StorageReference
    
    init(storageDir: String) {
        storeRef = Storage.storage().reference().child(storageDir)
    }
    
    func downloadImage(imagePath:String, completion:@escaping ((UIImage) -> Void)) {
        let imageRef = storeRef.child(imagePath)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error occured when downloading: \(error)")
            } else {
                if let image = UIImage(data: data!) {
                   completion(image)
                }
            }
        }
    }
    
    func uploadImage(image: UIImage, imageName: String, completionHandler: @escaping ((String) -> Void)) {
        if let imageData = image.pngData() {
            storeRef.child("\(imageName).png").putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error occurred when uploading: \(error)")
                    return
                }
                completionHandler(imageName)
            }
        }
    }
}
