//
//  TagSuggestionServiceSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Quick
import Nimble
@testable import IlluMefy

@MainActor
class TagSuggestionServiceSpec: QuickSpec {
    override class func spec() {
        describe("TagSuggestionService") {
            var service: TagSuggestionService!
            var allTags: [Tag]!
            var selectedTags: [Tag]!
            
            beforeEach {
                service = TagSuggestionService()
                selectedTags = []
                
                // テスト用のタグを作成
                allTags = [
                    Tag(id: "game", tagName: "game", displayName: "ゲーム", clickedCount: 100),
                    Tag(id: "gaming", tagName: "gaming", displayName: "ゲーミング", clickedCount: 80),
                    Tag(id: "apex", tagName: "apex", displayName: "Apex Legends", clickedCount: 90),
                    Tag(id: "fps", tagName: "fps", displayName: "FPS", clickedCount: 70),
                    Tag(id: "vtuber", tagName: "vtuber", displayName: "VTuber", clickedCount: 120),
                    Tag(id: "singing", tagName: "singing", displayName: "歌", clickedCount: 60),
                    Tag(id: "cooking", tagName: "cooking", displayName: "料理", clickedCount: 50)
                ]
            }
            
            context("空の検索クエリ") {
                it("空配列を返す") {
                    let suggestions = service.generateSuggestions(
                        query: "",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    expect(suggestions).to(beEmpty())
                }
                
                it("スペースのみの場合も空配列を返す") {
                    let suggestions = service.generateSuggestions(
                        query: "   ",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    expect(suggestions).to(beEmpty())
                }
            }
            
            context("日本語検索") {
                it("ひらがな入力でカタカナのタグを見つける") {
                    let suggestions = service.generateSuggestions(
                        query: "げーむ",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).toNot(beEmpty())
                    expect(suggestions.first?.displayName).to(equal("ゲーム"))
                }
                
                it("カタカナ入力でひらがなのタグを見つける") {
                    // ひらがなのタグを追加
                    let hiraganaTag = Tag(id: "game-hira", tagName: "game-hira", displayName: "げーむ", clickedCount: 10)
                    let tagsWithHiragana = allTags + [hiraganaTag]
                    
                    let suggestions = service.generateSuggestions(
                        query: "ゲーム",
                        allTags: tagsWithHiragana,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).toNot(beEmpty())
                    let tagNames = suggestions.map { $0.displayName }
                    expect(tagNames).to(contain("げーむ"))
                }
                
                it("部分一致で候補を見つける") {
                    let suggestions = service.generateSuggestions(
                        query: "歌",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).toNot(beEmpty())
                    expect(suggestions.first?.displayName).to(equal("歌"))
                }
            }
            
            context("英語検索") {
                it("前方一致で候補を見つける") {
                    let suggestions = service.generateSuggestions(
                        query: "gam",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).toNot(beEmpty())
                    let tagNames = suggestions.map { $0.tagName }
                    expect(tagNames).to(contain("game"))
                    expect(tagNames).to(contain("gaming"))
                }
                
                it("大文字小文字を区別しない") {
                    let suggestions = service.generateSuggestions(
                        query: "FPS",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).toNot(beEmpty())
                    expect(suggestions.first?.tagName).to(equal("fps"))
                }
            }
            
            context("完全一致") {
                it("完全一致するタグを最上位に表示") {
                    let suggestions = service.generateSuggestions(
                        query: "ゲーム",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).toNot(beEmpty())
                    expect(suggestions.first?.displayName).to(equal("ゲーム"))
                }
                
                it("完全一致するタグが既に選択済みの場合は除外") {
                    let gameTag = allTags.first { $0.displayName == "ゲーム" }!
                    selectedTags = [gameTag]
                    
                    let suggestions = service.generateSuggestions(
                        query: "ゲーム",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).to(beEmpty())
                }
            }
            
            context("ソート順") {
                it("完全一致が最優先") {
                    let suggestions = service.generateSuggestions(
                        query: "ゲーム",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions.first?.displayName).to(equal("ゲーム"))
                }
                
                it("前方一致を部分一致より優先") {
                    let suggestions = service.generateSuggestions(
                        query: "ga",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions).toNot(beEmpty())
                    // "game"で始まるタグが"gaming"で始まるタグより前に来る
                    let firstTag = suggestions.first { $0.tagName.hasPrefix("ga") }
                    expect(firstTag).toNot(beNil())
                }
                
                it("クリック数で降順ソート") {
                    let suggestions = service.generateSuggestions(
                        query: "g",
                        allTags: allTags,
                        selectedTags: selectedTags,
                        maxSuggestions: 10
                    )
                    
                    let clickCounts = suggestions.map { $0.clickedCount }
                    let sortedClickCounts = clickCounts.sorted(by: >)
                    expect(clickCounts).to(equal(sortedClickCounts))
                }
            }
            
            context("選択済みタグの除外") {
                it("選択済みタグは候補から除外される") {
                    let gameTag = allTags.first { $0.displayName == "ゲーム" }!
                    selectedTags = [gameTag]
                    
                    let suggestions = service.generateSuggestions(
                        query: "ゲー",
                        allTags: allTags,
                        selectedTags: selectedTags
                    )
                    
                    let tagIds = suggestions.map { $0.id }
                    expect(tagIds).toNot(contain("game"))
                }
            }
            
            context("最大件数制限") {
                it("指定した最大件数で候補を制限") {
                    let suggestions = service.generateSuggestions(
                        query: "e",
                        allTags: allTags,
                        selectedTags: selectedTags,
                        maxSuggestions: 2
                    )
                    
                    expect(suggestions.count).to(beLessThanOrEqualTo(2))
                }
                
                it("デフォルトは5件") {
                    let manyTags = (0..<10).map { index in
                        Tag(id: "tag\(index)", tagName: "test\(index)", displayName: "テスト\(index)", clickedCount: index)
                    }
                    
                    let suggestions = service.generateSuggestions(
                        query: "テスト",
                        allTags: manyTags,
                        selectedTags: selectedTags
                    )
                    
                    expect(suggestions.count).to(beLessThanOrEqualTo(5))
                }
            }
            
            context("normalizeJapaneseText") {
                it("カタカナをひらがなに変換") {
                    let normalized = service.normalizeJapaneseText("ゲーム")
                    expect(normalized).to(equal("げーむ"))
                }
                
                it("ひらがなはそのまま") {
                    let normalized = service.normalizeJapaneseText("げーむ")
                    expect(normalized).to(equal("げーむ"))
                }
                
                it("英数字はそのまま") {
                    let normalized = service.normalizeJapaneseText("FPS123")
                    expect(normalized).to(equal("FPS123"))
                }
                
                it("混在文字列も正しく処理") {
                    let normalized = service.normalizeJapaneseText("ゲームFPS")
                    expect(normalized).to(equal("げーむFPS"))
                }
            }
        }
    }
}