//
//  SearchResultCard.swift
//  IMDb Clone SwiftUI
//
//  Created by Quin Design on 6/13/22.
//

import SwiftUI

struct SearchResultCard: View {
	
	var dataModel: ContentSearchModel
	
	var body: some View {
		VStack{
			
			if dataModel.Poster ?? "" != "N/A" && !((dataModel.Poster ?? "").isEmpty) {
				AsyncImage(
					url: URL(string: dataModel.Poster ?? ""),
					content: { image in
						NavigationLink(destination: SearchResultsDetailView(image: image, imdbId: self.dataModel.imdbID ?? "", title: self.dataModel.Title ?? "")){
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
						}
					},
					placeholder: {
						ProgressView()
					}
				)
			}
			else {
				NavigationLink(destination: SearchResultsDetailView(image: Image(systemName: "xmark.octagon.fill"), imdbId: self.dataModel.imdbID ?? "", title: self.dataModel.Title ?? "")){
					Image(systemName: "xmark.octagon.fill")
						.frame(height: 150)
				}
			}
			Text("\(dataModel.Title ?? "")")
				.font(.body)
				.fontWeight(.bold)
			Text("\(self.yearToYearsPassed(releaseYear: dataModel.Year ?? ""))")
				.font(.body)
			Text("\(dataModel.`Type` ?? "")".capitalized)
				.font(.caption)
		}
		.onAppear {
			print("Image URL: \(dataModel.Poster ?? "Not Present")")
		}
	}
	
	func yearToYearsPassed(releaseYear: String) -> String {
		//      var formatter = DateFormatter()
		//      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
		//      let dateFromString = formatter.date(from: date)
		let year = Calendar.current.component(.year, from: Date())
		let yearsPassed = Int(year) - (Int(releaseYear) ?? Int(year))
		if yearsPassed > 0{
			return "\(yearsPassed) years ago"
		}
		else {
			return "\(releaseYear)"
		}
	}
}
