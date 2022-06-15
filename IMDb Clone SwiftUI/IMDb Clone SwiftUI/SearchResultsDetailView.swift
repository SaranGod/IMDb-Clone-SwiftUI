//
//  SearchResultsDetailView.swift
//  IMDb Clone SwiftUI
//
//  Created by Saran Goda on 6/14/22.
//

import SwiftUI
import Combine

struct SearchResultsDetailView: View {
	
	@State var image: Image
	@State var shouldImageAppear = false
	@State var shouldContentAppear = false
	var imdbId: String
	var title: String
	@State var dataModel: ContentDetailsModel = ContentDetailsModel()
	@State private var cancellables = Set<AnyCancellable>()
	
    var body: some View {
		ScrollView(showsIndicators: false){
			VStack{
				if self.shouldImageAppear{
					self.image
						.transition(.move(edge: .trailing))
				}
				if self.shouldContentAppear && self.shouldImageAppear {
					VStack(alignment: .leading){
						HStack{
							Text("\(dataModel.`Type` ?? "")".capitalized)
							if dataModel.`Type` != "movie" || dataModel.`Type` != "N/A"{
								if !(dataModel.totalSeasons?.isEmpty ?? true) && dataModel.totalSeasons != "N/A"{
									Text("\(dataModel.totalSeasons ?? "") Seasons")
								}
							}
							Spacer()
						}
						Text("\(dataModel.Genre ?? "")")
						Text("Released: \(dataModel.Released ?? "")")
							.font(.title3)
							.fontWeight(.semibold)
						Text("Language(s): \(dataModel.Language ?? "")")
						Text("Country: \(dataModel.Country ?? "")")
						DisclosureGroup("Plot"){
							Text("\(dataModel.Plot ?? "")")
								.font(.body)
						}
						DisclosureGroup("Cast"){
							Text("\(dataModel.Actors ?? "")")
								.font(.body)
						}
						DisclosureGroup("Crew"){
							VStack{
								Text("Writer(s): \(dataModel.Writer ?? "")")
								Text("Director(s): \(dataModel.Director ?? "")")
							}
						}
						DisclosureGroup("Awards & Ratings"){
							Text("Awards: \(dataModel.Awards ?? "")")
							Text("iMDb Rating: \(dataModel.imdbRating ?? "")")
							Text("Metacritic Rating: \(dataModel.Metascore ?? "")")
						}

					}
					.transition(.move(edge: .bottom))
				}
			}
		}
		.padding(.horizontal)
		.onAppear(){
			NetworkManager.shared.getData(endpoint: "https://www.omdbapi.com/?i=\(self.imdbId)", type: ContentDetailsModel.self)
				.sink { completion in
					switch completion {
						case .failure(let err):
							print("Error is \(err.localizedDescription)")
						case .finished:
							print("Finished")
					}
				} receiveValue: {
					self.dataModel = $0
					withAnimation(.spring()){
						self.shouldContentAppear = true
						print(self.dataModel)
					}
				}
				.store(in: &cancellables)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				withAnimation(.spring()){
					self.shouldImageAppear = true
				}
			}
		}
		.navigationTitle(self.title)
		.navigationBarTitleDisplayMode(.inline)
    }
}
