//
//  KingfisherService.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/11.
//

import UIKit

import Kingfisher


final class LHKingFisherService {

    static func fetchImage(with urlString: String) async throws -> UIImage? {
        typealias imageContinuation = CheckedContinuation<UIImage?, Error>

        return try await withCheckedThrowingContinuation { imageContinuation in

            guard let url = URL(string: urlString) else {
                return imageContinuation.resume(throwing: NetworkError.urlEncodingError)

            }
            
            let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                case .success(let imageResult):
                    let image = imageResult.image
                    return imageContinuation.resume(returning: image)
                case .failure(_):
                    return imageContinuation.resume(throwing: NetworkError.fetchImageError)
                }
            }
        }
        
    }

}
