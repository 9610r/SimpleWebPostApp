//
//  APIService.swift
//  SimpleWebPostApp
//
//  Created by 中島 on 2023/05/23.
//

import Foundation
import RxSwift
import RxCocoa


struct ApiIpResponse: Codable {
    let origin: String
}

class APIService {

    /// IPアドレスを返すサイトにリクエストを送信する
    /// - Returns: 自身のグローバルIP
    func sendIPRequest() -> Observable<String> {
        // リクエストの作成
        guard let url = URL(string: "https://httpbin.org/ip") else {
            return Observable.error(NSError(domain: "", code: -1, userInfo: .none))
        }
        var request = URLRequest(url: url)
        // POSTだと405が返ってくるので注意
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // リクエストの送信処理を行う
        return URLSession.shared.rx.response(request: request)
            .map { _, data -> String in
                guard let response = try? JSONDecoder().decode(ApiIpResponse.self, from: data) else {
                    throw NSError(domain: "", code: -1, userInfo: .none)
                }
                return response.origin
            }
    }
}
