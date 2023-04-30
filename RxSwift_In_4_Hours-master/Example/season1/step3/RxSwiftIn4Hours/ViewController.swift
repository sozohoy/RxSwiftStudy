//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
//        .filter { $0 != nil }
//        .map { $0! }
        idField.rx.text.orEmpty 
            .map(checkEmailValid)
            .subscribe { bool in
                self.idValidView.isHidden = bool
            }
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe { bool in
                self.pwValidView.isHidden = bool
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            idField.rx.text.orEmpty.map(checkEmailValid),
            pwField.rx.text.orEmpty.map(checkPasswordValid)) { id, pwd in
            id && pwd
            }
            .subscribe { bool in
                self.loginButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
