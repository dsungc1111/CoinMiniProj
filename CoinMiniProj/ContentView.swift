//
//  ContentView.swift
//  CoinMiniProj
//
//  Created by 최대성 on 9/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
//        NavigationView {
            ScrollView(.vertical) {
                myFavoriteView()
                topCoin("Top 15 Coin")
                topCoin("Top 7 NFT")
            }
            .scrollIndicators(.hidden)
            
//        }
        
    }
    
    
    func topCoin(_ title: String) -> some View {
        VStack {
            Text(title)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding()
            ScrollView(.horizontal) {
                LazyHGrid(
                    rows: [
                        GridItem(.fixed(100)),
                        GridItem(.fixed(100)),
                        GridItem(.fixed(100))
                    ],
                    spacing: 20
                ) {
                    ForEach(0..<6) { _ in
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 290, height: 100)
                    }
                }
                .padding(.horizontal, 10)
            }
            .scrollIndicators(.hidden)
        }
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

#Preview {
    MainView()
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
