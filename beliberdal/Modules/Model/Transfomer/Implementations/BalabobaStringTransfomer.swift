//
//  BalabobaStringTransfomer.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 06.09.2021.
//

import Foundation
import Combine

final class BalabobaStringTransformer: StringTransformerProtocol {

    static var name: String { "Balaboba" }
    
    enum Modes: Int, CaseIterable {
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
    
    var currentMode: Modes
    
    private let networkClient = NetworkClient()
    
    init(for mode: Modes) {
        currentMode = mode
    }

    func transform(_ string: String) -> AnyPublisher<String, Error> {
        let body = BalabobaEndpoint.Body(query: string, intro: currentMode.rawValue)
        let request = jsonPostRequest(endpoint: BalabobaEndpoint.endpoint, jsonBody: body)
        
        return networkClient.perform(request)
            .decode(type: BalabobaEndpoint.Response.self, decoder: JSONDecoder())
            .map { "\($0.query + $0.text)" }
            .eraseToAnyPublisher()
    }
    
}

extension BalabobaStringTransformer {
    
    struct BalabobaEndpoint {
        
        static var endpoint = "https://zeapi.yandex.net/lab/api/yalm/text3"
        
        struct Body: Encodable {
            let query: String
            let intro: Int
            let filter: Int = 1
        }
        
        struct Response: Decodable {
            let bad_query: Int
            let error: Int
            let query: String
            let text: String
        }
        
    }
    
}
