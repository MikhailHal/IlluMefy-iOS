//
//  TagApplicationViewModelSpec.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
import Quick
import Nimble
@testable import IlluMefy

@MainActor
final class TagApplicationViewModelSpec: QuickSpec, @unchecked Sendable {
    override class func spec() {
        var viewModel: TagApplicationViewModel!
        var mockSubmitTagApplicationUseCase: MockSubmitTagApplicationUseCase!
        var testCreator: Creator!
        
        describe("TagApplicationViewModel") {
            beforeEach {
                mockSubmitTagApplicationUseCase = MockSubmitTagApplicationUseCase()
                
                testCreator = Creator(
                    id: "test-creator-id",
                    name: "Test Creator",
                    thumbnailUrl: "https://example.com/thumbnail.jpg",
                    viewCount: 1000,
                    socialLinkClickCount: 500,
                    platformClickRatio: [.youtube: 0.6, .x: 0.4],
                    relatedTag: ["Gaming"],
                    description: "Test creator description",
                    platform: [.youtube: "https://youtube.com/test"],
                    createdAt: Date(),
                    updatedAt: Date(),
                    isActive: true
                )
                
                viewModel = TagApplicationViewModel(
                    creator: testCreator,
                    applicationType: .add,
                    submitTagApplicationUseCase: mockSubmitTagApplicationUseCase
                )
            }
            
            afterEach {
                mockSubmitTagApplicationUseCase.reset()
            }
            
            context("initialization") {
                it("should initialize with default values") {
                    expect(viewModel.tagName).to(equal(""))
                    expect(viewModel.reason).to(equal(""))
                    expect(viewModel.applicationType).to(equal(.add))
                    expect(viewModel.isSubmitting).to(beFalse())
                    expect(viewModel.showingResult).to(beFalse())
                    expect(viewModel.isSuccess).to(beFalse())
                    expect(viewModel.resultMessage).to(equal(""))
                }
                
                it("should store creator and application type") {
                    expect(viewModel.creator.id).to(equal("test-creator-id"))
                    expect(viewModel.applicationType).to(equal(.add))
                    
                    // Test with remove type
                    let removeViewModel = TagApplicationViewModel(
                        creator: testCreator,
                        applicationType: .remove,
                        submitTagApplicationUseCase: mockSubmitTagApplicationUseCase
                    )
                    expect(removeViewModel.applicationType).to(equal(.remove))
                }
            }
            
            context("computed properties") {
                context("isSubmitEnabled") {
                    it("should be false when tag name is empty") {
                        viewModel.tagName = ""
                        expect(viewModel.isSubmitEnabled).to(beFalse())
                    }
                    
                    it("should be false when tag name is only whitespace") {
                        viewModel.tagName = "   "
                        expect(viewModel.isSubmitEnabled).to(beFalse())
                    }
                    
                    it("should be true when tag name has content") {
                        viewModel.tagName = "Gaming"
                        expect(viewModel.isSubmitEnabled).to(beTrue())
                    }
                    
                    it("should be false when submitting") {
                        viewModel.tagName = "Gaming"
                        viewModel.isSubmitting = true
                        expect(viewModel.isSubmitEnabled).to(beFalse())
                    }
                }
                
                context("tagNameCharacterCount") {
                    it("should return formatted character count") {
                        viewModel.tagName = "Test"
                        expect(viewModel.tagNameCharacterCount).to(equal(L10n.TagApplication.characterCount(4)))
                        
                        viewModel.tagName = "A very long tag name"
                        expect(viewModel.tagNameCharacterCount).to(equal(L10n.TagApplication.characterCount(20)))
                    }
                }
                
                context("reasonCharacterCount") {
                    it("should return formatted character count") {
                        viewModel.reason = ""
                        expect(viewModel.reasonCharacterCount).to(equal("0/200文字"))
                        
                        viewModel.reason = "Test reason"
                        expect(viewModel.reasonCharacterCount).to(equal("11/200文字"))
                        
                        let longReason = String(repeating: "a", count: 150)
                        viewModel.reason = longReason
                        expect(viewModel.reasonCharacterCount).to(equal("150/200文字"))
                    }
                }
            }
            
            context("validation methods") {
                context("validateTagName") {
                    it("should return original value when within limit") {
                        let shortTag = "Gaming"
                        expect(viewModel.validateTagName(shortTag)).to(equal(shortTag))
                        
                        let maxLengthTag = String(repeating: "a", count: 50)
                        expect(viewModel.validateTagName(maxLengthTag)).to(equal(maxLengthTag))
                    }
                    
                    it("should truncate when exceeding limit") {
                        let longTag = String(repeating: "a", count: 60)
                        let truncated = viewModel.validateTagName(longTag)
                        expect(truncated.count).to(equal(50))
                        expect(truncated).to(equal(String(repeating: "a", count: 50)))
                    }
                }
                
                context("validateReason") {
                    it("should return original value when within limit") {
                        let shortReason = "This is a test reason"
                        expect(viewModel.validateReason(shortReason)).to(equal(shortReason))
                        
                        let maxLengthReason = String(repeating: "a", count: 200)
                        expect(viewModel.validateReason(maxLengthReason)).to(equal(maxLengthReason))
                    }
                    
                    it("should truncate when exceeding limit") {
                        let longReason = String(repeating: "a", count: 250)
                        let truncated = viewModel.validateReason(longReason)
                        expect(truncated.count).to(equal(200))
                        expect(truncated).to(equal(String(repeating: "a", count: 200)))
                    }
                }
            }
            
            context("submitApplication") {
                context("when validation passes") {
                    beforeEach {
                        viewModel.tagName = "TestTag"
                        viewModel.reason = "Test reason"
                        mockSubmitTagApplicationUseCase.shouldSucceed = true
                    }
                    
                    it("should submit successfully and update state") {
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(viewModel.isSubmitting).to(beFalse())
                                expect(viewModel.isSuccess).to(beTrue())
                                expect(viewModel.showingResult).to(beTrue())
                                expect(viewModel.resultMessage).to(equal("タグ申請を受け付けました。審査結果をお待ちください。"))
                                
                                expect(mockSubmitTagApplicationUseCase.executeCallCount).to(equal(1))
                                expect(mockSubmitTagApplicationUseCase.lastExecutedRequest?.creatorId).to(equal("test-creator-id"))
                                expect(mockSubmitTagApplicationUseCase.lastExecutedRequest?.tagName).to(equal("TestTag"))
                                expect(mockSubmitTagApplicationUseCase.lastExecutedRequest?.reason).to(equal("Test reason"))
                                expect(mockSubmitTagApplicationUseCase.lastExecutedRequest?.applicationType).to(equal(.add))
                                
                                done()
                            }
                        }
                    }
                    
                    it("should handle empty reason correctly") {
                        viewModel.reason = ""
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(mockSubmitTagApplicationUseCase.lastExecutedRequest?.reason).to(beNil())
                                done()
                            }
                        }
                    }
                    
                    it("should use custom response when provided") {
                        let customApplication = TagApplication(
                            id: "custom-id",
                            creatorId: "test-creator-id",
                            tagName: "CustomTag",
                            reason: "Custom reason",
                            applicationType: .add,
                            status: .approved,
                            requestedAt: Date(),
                            reviewedAt: nil,
                            reviewerId: nil,
                            reviewComment: nil
                        )
                        let customResponse = SubmitTagApplicationUseCaseResponse(application: customApplication)
                        mockSubmitTagApplicationUseCase.mockResponse = customResponse
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(viewModel.resultMessage).to(equal("タグ申請を受け付けました。審査結果をお待ちください。"))
                                done()
                            }
                        }
                    }
                }
                
                context("when submission fails") {
                    beforeEach {
                        viewModel.tagName = "TestTag"
                        mockSubmitTagApplicationUseCase.shouldSucceed = false
                    }
                    
                    it("should handle network error") {
                        mockSubmitTagApplicationUseCase.mockError = .networkError
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(viewModel.isSubmitting).to(beFalse())
                                expect(viewModel.isSuccess).to(beFalse())
                                expect(viewModel.showingResult).to(beTrue())
                                expect(viewModel.resultMessage).to(equal(SubmitTagApplicationUseCaseError.networkError.localizedDescription))
                                
                                done()
                            }
                        }
                    }
                    
                    it("should handle validation error") {
                        mockSubmitTagApplicationUseCase.mockError = .invalidTagName
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(viewModel.isSuccess).to(beFalse())
                                expect(viewModel.resultMessage).to(equal(SubmitTagApplicationUseCaseError.invalidTagName.localizedDescription))
                                
                                done()
                            }
                        }
                    }
                    
                    it("should handle duplicate application error") {
                        mockSubmitTagApplicationUseCase.mockError = .duplicateApplication
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(viewModel.isSuccess).to(beFalse())
                                expect(viewModel.resultMessage).to(equal(SubmitTagApplicationUseCaseError.duplicateApplication.localizedDescription))
                                
                                done()
                            }
                        }
                    }
                    
                    it("should handle unexpected error") {
                        mockSubmitTagApplicationUseCase.shouldThrowUnexpectedError = true
                        
                        waitUntil(timeout: .seconds(3)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(viewModel.isSuccess).to(beFalse())
                                expect(viewModel.showingResult).to(beTrue())
                                expect(viewModel.resultMessage).toNot(beEmpty())
                                
                                done()
                            }
                        }
                    }
                }
                
                context("when submit is disabled") {
                    it("should not submit when tag name is empty") {
                        viewModel.tagName = ""
                        
                        waitUntil(timeout: .seconds(1)) { done in
                            Task {
                                await viewModel.submitApplication()
                                
                                expect(mockSubmitTagApplicationUseCase.executeCallCount).to(equal(0))
                                expect(viewModel.isSubmitting).to(beFalse())
                                
                                done()
                            }
                        }
                    }
                }
            }
            
            context("resetFormData") {
                it("should reset all form data to initial state") {
                    // Set some values
                    viewModel.tagName = "TestTag"
                    viewModel.reason = "Test reason"
                    
                    // Simulate a successful submission first
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            await viewModel.submitApplication()
                            
                            // Verify we have a result before reset
                            expect(viewModel.isSuccess).to(beTrue())
                            expect(viewModel.resultMessage).toNot(beEmpty())
                            
                            // Reset
                            viewModel.resetFormData()
                            
                            // Verify reset
                            expect(viewModel.tagName).to(equal(""))
                            expect(viewModel.reason).to(equal(""))
                            expect(viewModel.isSuccess).to(beFalse())
                            expect(viewModel.resultMessage).to(equal(""))
                            
                            done()
                        }
                    }
                }
                
                it("should not affect other properties") {
                    let originalCreator = viewModel.creator
                    let originalApplicationType = viewModel.applicationType
                    
                    viewModel.tagName = "TestTag"
                    viewModel.resetFormData()
                    
                    expect(viewModel.creator.id).to(equal(originalCreator.id))
                    expect(viewModel.applicationType).to(equal(originalApplicationType))
                }
            }
            
            context("application type behavior") {
                it("should work correctly with add type") {
                    let addViewModel = TagApplicationViewModel(
                        creator: testCreator,
                        applicationType: .add,
                        submitTagApplicationUseCase: mockSubmitTagApplicationUseCase
                    )
                    
                    addViewModel.tagName = "NewTag"
                    
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            await addViewModel.submitApplication()
                            
                            expect(mockSubmitTagApplicationUseCase.lastExecutedRequest?.applicationType).to(equal(.add))
                            done()
                        }
                    }
                }
                
                it("should work correctly with remove type") {
                    let removeViewModel = TagApplicationViewModel(
                        creator: testCreator,
                        applicationType: .remove,
                        submitTagApplicationUseCase: mockSubmitTagApplicationUseCase
                    )
                    
                    removeViewModel.tagName = "ExistingTag"
                    
                    waitUntil(timeout: .seconds(3)) { done in
                        Task {
                            await removeViewModel.submitApplication()
                            
                            expect(mockSubmitTagApplicationUseCase.lastExecutedRequest?.applicationType).to(equal(.remove))
                            done()
                        }
                    }
                }
            }
        }
    }
}