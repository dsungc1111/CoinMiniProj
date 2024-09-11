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
    
    var body: some View {
        
        NavigationView {
            VStack {
                if newList.isEmpty {
                    Text("No Results")
                        .padding()
                } else {
                    List(newList, id: \.self) { item in
                        
                        HStack {
                            let image = URL(string: item.thumb)!
                            
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

                            VStack(alignment: .leading) {
                                highlightText(item.name, searchText: text)
                                    .font(.system(size: 14))
                                    .bold()
                                Text(item.symbol)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Button(action: {
                                print("버튼클릭")
                            }, label: {
                                Image(systemName: "star")
                                    .foregroundStyle(.purple)
                            })
                        }
                        
                    }
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

    
    private func highlightText(_ text: String, searchText: String) -> Text {
        
        
        let parts = text.components(separatedBy: searchText)
        print("parts = ", parts)
        
        var result: Text = Text("")
        
        for (index, part) in parts.enumerated() {
            if index > 0 {
                result = result + Text(searchText).foregroundColor(.purple).font(.system(size: 15))
            }
            result = result + Text(part)
        }
        
        return result
    }
    
    private func searchCoin() async {
        do {
            let result = try await CoinNetwork.fetchCoin(query: text)
            newList = result.coins
        } catch {
            print("Error fetching coin data: \(error)")
        }
    }
}
