//
//  NetworkManager.swift
//  IMDb Clone SwiftUI
//
//  Created by Quin Design on 6/13/22.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

class NetworkManager {
    
    static let shared = NetworkManager()
	
	let apiKey = "ddd0858d"
    
    private init() {
        
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func getData<T: Decodable>(endpoint: String, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: "\(endpoint)&apikey=\(self.apiKey)") else {
                return promise(.failure(NetworkError.invalidURL))
            }
//            print("URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}

class PaginationSearch: ObservableObject {
    
    @Published var searchResults = SearchResultModel()
    
    @Published var shouldDisplay = false
    
    @Published var isSearching = false
    
    var isEverythingFetched = false
    
    var pageNumber = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    func getSearchResults(searchString: String) {
        
        self.isSearching = true
        
        var cleanedString = searchString.replacingOccurrences(of: " ", with: "%20")
        //
        //        let url = URL(string: "https://www.omdbapi.com/?s=\(cleanedString)&page=\(self.pageNumber)&apikey=\(self.apiKey)")!
        //
        //        publisherTask = URLSession.shared.dataTaskPublisher(for: url)s
        //            .tryMap { $0.data }
        //            .decode(type: SearchResultModel.self, decoder: JSONDecoder())
        //            .receive(on: RunLoop.main)
        //            .catch { err -> Just in
        //                print("Error \(err)")
        //                return Just(self.searchResults)
        //            }
        NetworkManager.shared.getData(endpoint: "https://www.omdbapi.com/?s=\(cleanedString)&page=\(self.pageNumber)", type: SearchResultModel.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            }
            receiveValue: { [weak self] in
                self?.isSearching = false
                self?.pageNumber += 1
                if self?.searchResults.Search != nil {
                    self?.searchResults.Search?.append(contentsOf: $0.Search ?? [])
                }
                else if self?.searchResults.Search == nil {
                    self?.searchResults.Search = $0.Search
                    self?.shouldDisplay = true
                }
                if self?.searchResults.totalResults == nil {
                    self?.searchResults.totalResults = $0.totalResults
                }
                if self?.searchResults.Response == nil {
                    self?.searchResults.Response = $0.Response
                }
                print("Results \(self?.searchResults.Search?.count)")
                if (self?.searchResults.Search?.count ?? 0) == (Int(self?.searchResults.totalResults ?? "") ?? 0) {
                    self?.isEverythingFetched = true
                }
            }
            .store(in: &cancellables)
    }
}
