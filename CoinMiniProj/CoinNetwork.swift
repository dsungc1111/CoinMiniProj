//
//  CoinNetwork.swift
//  CoinMiniProj
//
//  Created by 최대성 on 9/10/24.
//

import Foundation


class CoinNetwork {
    
    private init() {}
    
    static func fetchCoinNFTInfo(completionHandler: @escaping (Coins?) -> Void) {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/search/trending") else {
                completionHandler(nil)
                return
            }
            
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                print("성공임")
                let decodedData = try JSONDecoder().decode( Coins.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(decodedData)
                }
            } catch {
                print("실패임")
                print(error)
            }
            
        
        }.resume()
    }
    
//    static func fetchCoin() async throws -> Coins {
//        let url = URL(string: "https://api.coingecko.com/api/v3/search/trending")!
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        let decodeData = try JSONDecoder().decode(Coins.self, from: data)
//        
//        return decodeData
//        
//    }
    
}
