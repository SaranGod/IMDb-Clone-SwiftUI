//
//  ContentView.swift
//  IMDb Clone SwiftUI
//
//  Created by Quin Design on 6/13/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var paginationMovieSearch = PaginationSearch()
    
    @State var searchString = ""
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        NavigationView{
            VStack{
                GeometryReader { proxy in
                    ScrollView(.vertical, showsIndicators: false){
						TextField("Search", text: self.$searchString)
							.onSubmit {
								self.paginationMovieSearch.searchResults = SearchResultModel()
								self.paginationMovieSearch.isEverythingFetched = false
								self.paginationMovieSearch.pageNumber = 1
								self.paginationMovieSearch.getSearchResults(searchString: "\(self.searchString)")
							}
                        if self.paginationMovieSearch.shouldDisplay{
                            LazyVGrid(columns: self.columns, spacing: 20){
								ForEach(paginationMovieSearch.searchResults.Search ?? [], id: \.self) { item in
									SearchResultCard(dataModel: item)
										.frame(width: proxy.size.width * 0.4, height: 300)
										.padding(10)
										.overlay(
											RoundedRectangle(cornerRadius: 10)
												.stroke(lineWidth: 2)
										)
								}
                                if !self.paginationMovieSearch.isEverythingFetched {
                                    ProgressView()
                                        .onAppear {
                                            self.paginationMovieSearch.getSearchResults(searchString: "\(self.searchString)")
                                        }
                                }
                            }
                            .padding(.top)
                        }
                        else if self.paginationMovieSearch.isSearching {
                            ProgressView()
                        }
                        else {
                            Text("Enter your query into the search box!")
                        }
                    }
                }
                .padding(.horizontal)
                .navigationTitle("iMDb")
                .navigationBarTitleDisplayMode(.large)
            }
        }
//        Text("Hello, world!")
//            .padding()
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
