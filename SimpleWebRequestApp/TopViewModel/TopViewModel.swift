//
//  TopViewModel.swift
//  SimpleWebPostApp
//
//  Created by 中島 on 2023/05/23.
//

import Foundation
import RxSwift
import RxCocoa

class TopViewModel {
    private let disposeBag = DisposeBag()
    private let apiService: APIService
    
    let inputText = BehaviorRelay<String?>(value: nil)
    let echoedText = BehaviorRelay<String?>(value: nil)
    let responseIp = BehaviorRelay<String?>(value: "Tap the button to display the global IP.")
    
    let buttonPressed = PublishRelay<Void>()
    
    // ViewModel の初期化を行うイニシャライザ
    init(apiService: APIService) {
        self.apiService = apiService
        self.inputText
            .compactMap { $0 }
            .flatMapLatest { text in
                return Observable.of(text)
            }
            .bind(to: self.inputText)
            .disposed(by: disposeBag)
        
        
        self.buttonPressed
            .flatMapLatest { _ in
                return apiService.sendIPRequest()
            }
            .bind(to: self.responseIp)
            .disposed(by: disposeBag)
    }
}

