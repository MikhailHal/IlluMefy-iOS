//
//  HomeViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/10.
//
import Foundation

@MainActor
protocol HomeViewModelProtocol: ObservableObject {
    var popularTags: [Tag] { get }
    var popularCreators: [Creator] { get }
    var recommendedCreators: [Creator] { get }
    var newArrivalCreators: [Creator] { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    
    func getPopularTagList() -> [Tag]
    func getPopularCreatorList() -> [Creator]
    func getRecommendedCreatorList() -> [Creator]
    func getNewArrivalsCreatorList() -> [Creator]
    
    func loadInitialData() async
    func refreshData() async
}
