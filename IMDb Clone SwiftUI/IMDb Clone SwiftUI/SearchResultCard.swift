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
            AsyncImage(
                url: URL(string: dataModel.Poster ?? ""),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            Text("\(dataModel.Title ?? "")")
            Text("\(dataModel.Year ?? "")")
            Text("\(dataModel.`Type` ?? "")")
        }
        .onAppear {
            print("Image URL: \(dataModel.Poster ?? "Not Present")")
        }
    }
}
