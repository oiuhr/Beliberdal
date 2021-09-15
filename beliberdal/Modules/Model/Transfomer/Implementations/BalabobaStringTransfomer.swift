//
//  BalabobaStringTransfomer.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 06.09.2021.
//

import Foundation
import Combine

final class BalabobaStringTransformer: StringTransformerProtocol {

    static var name: String { "Балабоба" }
    
    var currentMode: Modes
    
    private let networkClient: NetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol
    
    init(for mode: Modes, networkClient: NetworkClientProtocol, requestBuilder: RequestBuilderProtocol) {
        currentMode = mode
        self.networkClient = networkClient
        self.requestBuilder = requestBuilder
    }

    func transform(_ string: String) -> AnyPublisher<String, Error> {
        let route = BalabobaEndPoint.transform(mode: currentMode.rawValue, query: string)
        guard let request = RequestBuilder().request(for: route) else {
            return Fail<String, Error>.init(error: StringTransformerError.undefined)
                .eraseToAnyPublisher()
        }
        
        return networkClient.perform(request)
            .decode(type: BalabobaEndPoint.Transform.Response.self, decoder: JSONDecoder())
            .map { "\($0.query + $0.text)" }
            .eraseToAnyPublisher()
    }
    
}

extension BalabobaStringTransformer {
    
    enum Modes: Int, CaseIterable, Codable {
        case none
        case conspiracyTheories
        case tvReports
        case toasts
        case quotes
        case advertisingSlogans
        case shortStories
        case instagramCaptions
        case wikiInShort
        case movieSynopsis
        case horoscopes
        case folkWisdom
        
        var modeDescription: String {
            switch self {
            case .none: return "Без стиля"
            case .conspiracyTheories: return "Теории заговора"
            case .tvReports: return "ТВ-репортажи"
            case .toasts: return "Тосты"
            case .quotes: return "Пацанские цитаты"
            case .advertisingSlogans: return "Рекламные слоганы"
            case .shortStories: return "Короткие истории"
            case .instagramCaptions: return "Подписи в Instagram"
            case .wikiInShort: return "Короче, Википедия"
            case .movieSynopsis: return "Синопсисы фильмов"
            case .horoscopes: return "Гороскоп"
            case .folkWisdom: return "Народные мудрости"
            }
        }
    }
    
}
