//
//  CoinModel.swift
//  CoinMiniProj
//
//  Created by 최대성 on 9/10/24.
//

import Foundation


struct CoinPriceChange: Hashable, Decodable {
    let krw: Double
}

struct CoinDetail: Hashable, Decodable {
    let price: Double
    let priceChange: CoinPriceChange
    
    enum CodingKeys: String, CodingKey {
        case price
        case priceChange = "price_change_percentage_24h"
    }
    
}

struct CoinItem: Hashable, Decodable {
    let id: String
    let name: String
    let symbol: String
    let small: String
    let data: CoinDetail
}

struct CoinInfo: Hashable, Decodable{
    let item: CoinItem
  
}

struct NFTDetail: Hashable, Decodable {
    let floor_price: String
    let floor_price_in_usd_24h_percentage_change: String
}

struct NFTs: Hashable, Decodable {
    let id: String
    let name: String
    let symbol: String
    let thumb: String
    let data: NFTDetail
}
struct Coins: Hashable, Decodable {
//    var id = UUID()
    let coins: [CoinInfo]
    let nfts: [NFTs]
}


//let dummy = Coins(coins: [Item(item: CoinItem(id: "", name: "", symbol: "", small: "", data: CoinDetail(price: 0.0, priceChange: CoinPriceChange(krw: 0.0))))])
