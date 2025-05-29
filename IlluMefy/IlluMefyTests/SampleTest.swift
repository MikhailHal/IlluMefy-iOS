//
//  SampleTest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/05/29.
//

import Nimble
import Quick
import Foundation

class SampleTestByUsingNimblePlusQuick: QuickSpec {
    override class func spec() {
        describe("サンプルテストだよ") {
            context("同期処理") {
                context("Int") {
                    it("正しい計算結果を返す場合") {
                        expect(1+1).to(equal(2))
                    }
                    
                    it("不正な計算結果を返す場合") {
                        expect(1+1).notTo(equal(3))
                    }
                }
                
                context("String") {
                    it("文字列比較が成功する場合") {
                        expect("hello world").to(equal("hello world"))
                    }
                    it("文字列加工が成功する場合") {
                        let str = "hello world".appending("!")
                        expect(str).to(equal("hello world!"))
                    }
                }
            }
            
            context("非同期処理") {
                it("非同期処理やってみた") {
                    waitUntil { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            expect(true).to(equal(true))
                            done()
                        }
                    }
                }
            }
            
            context("カウントアップ") {
                var counter = 0
                beforeEach {
                    counter = 0
                    expect(counter).to(equal(0))
                }
                
                afterEach {
                    counter = -1
                    expect(counter).to(equal(-1))
                }
                
                it("成功する場合") {
                    for i in 0..<10 {
                        counter += 1
                        expect(counter).to(equal(i+1))
                    }
                }
            }
        }
    }
}
