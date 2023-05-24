//
//  ViewController.swift
//  SimpleWebPostApp
//
//  Created by 中島 on 2023/05/22.
//

import UIKit
import RxSwift
import RxCocoa

class TopViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private let viewModel = TopViewModel(apiService: APIService())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        // テキストフィールドに入力すると、入力したテキストがviewModelのechoedTextに反映する。
        textField.rx.text.orEmpty
            .bind(to: viewModel.echoedText)
            .disposed(by: disposeBag)
        
        // viewModelのechoedTextが変更されると、入力したテキストがラベルに反映される。
        viewModel.echoedText
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind(to: viewModel.buttonPressed)
            .disposed(by: disposeBag)
        
        viewModel.responseIp
            // メインスレッドで実行
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] ip in
                guard let self else { return }
                self.ipLabel.text = ip
            })
        
            .disposed(by: disposeBag)
    }
}
