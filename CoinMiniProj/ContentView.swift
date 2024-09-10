//
//  ContentView.swift
//  CoinMiniProj
//
//  Created by 최대성 on 9/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var myFavoriteList: [Coins] = []
    
    
    @State private var topCoinList: [CoinInfo] = []
    @State private var topNFTList: [NFTs] = []
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                myFavoriteView()
                topCoin("Top 15 Coin", list: topCoinList)
                topNFT("Top 7 NFT", list: topNFTList)
            }
            .task {
                CoinNetwork.fetchCoinNFTInfo { result in
                    if let result = result {
                        topCoinList = result.coins
                        topNFTList = result.nfts
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    func topCoin(_ title: String, list: [CoinInfo]) -> some View {
        
        VStack {
            sectionTitleView(title)
            ScrollView(.horizontal) {
                LazyHGrid(
                    rows: [
                        GridItem(.fixed(100)),
                        GridItem(.fixed(100)),
                        GridItem(.fixed(100))
                    ],
                    spacing: 20
                ) {
                    ForEach(list.indices, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .frame(width: 290, height: 100)
                            HStack {
                                Text("\(index + 1)")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .bold()
                                    .padding(10)
                                
                                let coinList = list[index].item
                                let image = URL(string: coinList.small)
                                
                                AsyncImage(url: image)
                                VStack {
                                    Text(coinList.name)
                                        .font(.system(size: 14))
                                    Text(coinList.symbol)
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 12))
                                }
                                Spacer()
                                VStack {
                                    Text("$" + String(format: "%.4f", coinList.data.price))
                                        .font(.system(size: 14))
                                    
                                    let value = coinList.data.priceChange.krw
                                    Text( value < 0 ? String(format: "%.2f",value) : "+" + String(format: "%.2f",value) + "%" )
                                        .foregroundStyle(Double(value) < 0 ? .blue : .red)
                                        .font(.system(size: 12))
                                }
                                .frame(alignment: .trailing)
                                
                            }
                        }
                        
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .scrollIndicators(.hidden)
    }
    func topNFT(_ title: String, list: [NFTs]) -> some View {
        
        VStack {
            sectionTitleView(title)
            ScrollView(.horizontal) {
                LazyHGrid(
                    rows: [
                        GridItem(.fixed(100)),
                        GridItem(.fixed(100)),
                        GridItem(.fixed(100))
                    ],
                    spacing: 20
                ) {
                    ForEach(list.indices, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .frame(width: 290, height: 100)
                            HStack {
                                Text("\(index + 1)")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .bold()
                                    .padding(10)
                                
                                let coinList = list[index]
                                let image = URL(string: coinList.thumb)
                                AsyncImage(url: image) { data in
                                    switch data {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                    case .failure(let error):
                                        ProgressView()
                                    default:
                                        ProgressView()
                                    }
                                }
                                VStack {
                                    Text(coinList.name)
                                        .font(.system(size: 14))
                                    Text(coinList.symbol)
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 12))
                                }
                                Spacer()
                                VStack {
                                    Text(coinList.data.floor_price)
                                        .font(.system(size: 14))
                                    let value = Double(coinList.data.floor_price_in_usd_24h_percentage_change) ?? 0.0
                                    Text( value < 0 ? String(format: "%.2f", value) + "%" : "+" + String(format: "%.2f", value) + "%")
                                        .foregroundStyle(value < 0 ? .blue : .red)
                                        .font(.system(size: 12))
                                }
                                .frame(alignment: .trailing)
                                
                            }
                        }
                        
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .scrollIndicators(.hidden)
    }
    
    func sectionTitleView(_ title: String) -> some View {
        Text(title)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .bold()
            .padding()
    }
    
    
    func myFavoriteView() -> some View {
        VStack {
            Text("My Favorite")
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<5) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 180, height: 130)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding()
        .navigationTitle("Crypto Coin")
    }
    
    
}



struct MainView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
                .tag(0)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            Text("즐겨찾기")
                .tabItem {
                    Image(systemName: "case")
                }
                .tag(2)
            Text("profile")
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
        }
        .font(.headline)
    }
}
