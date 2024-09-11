//
//  SearchView.swift
//  CoinMiniProj
//
//  Created by 최대성 on 9/10/24.
//

import SwiftUI

struct SearchView: View {
    
    @State private var newList: [ResultCoin] = []
    @State private var text = ""
    @State private var likeList: [ResultCoin] = []
    
    var body: some View {
        
        NavigationView {
            VStack {
                if newList.isEmpty {
                    Text("No Results")
                        .padding()
                } else {
                    ListView(newList: $newList, likeList: $likeList, text: $text)
                }
            }
            .navigationTitle("Search")
        }
        .searchable(text: $text)
        .onSubmit(of: .search) {
            Task {
                await searchCoin()
            }
        }
    }
    
    
    private func searchCoin() async {
        do {
            newList = []
            let result = try await CoinNetwork.fetchCoin(query: text)
            let newCoins = result.coins
            
            for newCoin in newCoins {
                if let index = likeList.firstIndex(where: { $0.id == newCoin.id }) {
                    newList.append(likeList[index])
                    print(newList[index].name)
                } else {
                    newList.append(newCoin)
                }
                
            }
            
        } catch {
            print("Error fetching coin data: \(error)")
        }
    }
}

struct ListView: View {
    
    @Binding var newList: [ResultCoin]
    @Binding var likeList: [ResultCoin]
    @State private var isLike = false
    @Binding var text: String
    
    var body: some View {
        List(newList.indices, id: \.self) { index in
            HStack {
                let image = URL(string: newList[index].thumb)!
                
                AsyncImage(url: image) { data in
                    switch data {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                    case .failure(_):
                        ProgressView()
                    default:
                        ProgressView()
                    }
                }
                VStack(alignment: .leading) {
                    highlightText(newList[index].name, searchText: text)
                        .font(.system(size: 14))
                        .bold()
                    Text(newList[index].symbol)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
                Spacer()
                Button(action: {
                    newList[index].isLike.toggle()
                    
                    if let index = likeList.firstIndex(where: { $0.id == newList[index].id }) {
                        
                        likeList.remove(at: index)
                    } else if newList[index].isLike {
                        
                        likeList.append(newList[index])
                    }
                    
                    
                }, label: {
                    Image(systemName: newList[index].isLike ? "star.fill" : "star")
                        .foregroundStyle(.purple)
                })
            }
            
        }
    }
    
    private func highlightText(_ text: String, searchText: String) -> Text {
        
        let lowercasedText = text.lowercased()
        let lowercasedSearchText = searchText.lowercased()
        
        let parts = lowercasedText.components(separatedBy: lowercasedSearchText)
        
        var result: Text = Text("")
        var searchIndex = lowercasedText.startIndex
        
        for (index, part) in parts.enumerated() {
            
            if index > 0 {
                let range = lowercasedText.range(of: lowercasedSearchText, options: .caseInsensitive, range: searchIndex..<lowercasedText.endIndex)!
                let highlightedText = text[range]
                result = result + Text(highlightedText).foregroundColor(.purple).font(.system(size: 15))
                searchIndex = range.upperBound
            }
            
            let originalPart = text[searchIndex..<text.index(searchIndex, offsetBy: part.count)]
            result = result + Text(originalPart)
            
            searchIndex = text.index(searchIndex, offsetBy: part.count)
        }
        
        return result
    }

}
