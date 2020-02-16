//
//  FlagQuizView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FlagQuizView: UIView {
  
  // MARK: - Properties
  
  var delegate: FlagQuizViewDelegate?
  
  private let quizStatusView: QuizStatusView = {
    let view = QuizStatusView()
    
    return view
  }()
  
  private let separatorView: SeparatorView = {
    let view = SeparatorView()
    
    return view
  }()
  
  private lazy var bannerView: GADBannerView = {
    let view = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.adUnitID = AdvertisingIdentifier.testBannerADUnitID
    view.delegate = self
    view.backgroundColor = .clear
    
    return view
  }()
  
  private let correctOrIncorrectView: CorrectOrIncorrectView = {
    let view = CorrectOrIncorrectView()
    
    return view
  }()
  
  private let flagImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  private lazy var questionView: QuestionView = {
    let view = QuestionView(buttonType: .system)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    
    return view
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    configureView()
    addAllView()
    setupAllAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = Color.tertiarySystemGroupedBackground
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    self.addSubview(quizStatusView)
    self.addSubview(separatorView)
    self.addSubview(bannerView)
    self.addSubview(correctOrIncorrectView)
    self.addSubview(flagImageView)
    self.addSubview(questionView)
  }
  
  private func setupAllAutoLayout() {
    setupLifeScoreViewAutoLayout()
    setupSeparatorViewAutoLayout()
    setupBannerViewAutoLayout()
    setupCorrectOrIncorrectViewAutoLayout()
    setupFlagImageViewAutoLayout()
    setupQuestionViewAutoLayout()
  }
  
  private func setupLifeScoreViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      quizStatusView.topAnchor     .constraint(equalTo: safeArea.topAnchor),
      quizStatusView.leadingAnchor .constraint(equalTo: safeArea.leadingAnchor,  constant: UI.Spacing.Leading.toSafeArea),
      quizStatusView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: UI.Spacing.Trailing.toSafeArea),
      quizStatusView.heightAnchor  .constraint(equalToConstant: UI.Size.quizStatusViewHeight),
    ])
  }
  
  private func setupSeparatorViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      separatorView.topAnchor     .constraint(equalTo: quizStatusView.bottomAnchor),
      separatorView.leadingAnchor .constraint(equalTo: safeArea      .leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: safeArea      .trailingAnchor),
    ])
  }
  
  private func setupBannerViewAutoLayout() {
    NSLayoutConstraint.activate([
      bannerView.topAnchor    .constraint(equalTo: separatorView.bottomAnchor),
      bannerView.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor)
    ])
    
  }
  
  private func setupCorrectOrIncorrectViewAutoLayout() {
    NSLayoutConstraint.activate([
      correctOrIncorrectView.topAnchor    .constraint(equalTo: bannerView.bottomAnchor, constant: UI.Spacing.Top.forCorrectOrIncorrectView),
      correctOrIncorrectView.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor),
    ])
  }
  
  private func setupFlagImageViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      flagImageView.topAnchor     .constraint(equalTo: separatorView.bottomAnchor,   constant: UI.Spacing.Top     .forFlagImageView),
      flagImageView.leadingAnchor .constraint(equalTo: safeArea     .leadingAnchor,  constant: UI.Spacing.Leading .forFlagImageView),
      flagImageView.trailingAnchor.constraint(equalTo: safeArea     .trailingAnchor, constant: UI.Spacing.Trailing.forFlagImageView),
      flagImageView.bottomAnchor  .constraint(equalTo: questionView .topAnchor,      constant: UI.Spacing.Bottom  .forFlagImageView),
    ])
    
  }
  
  private func setupQuestionViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      questionView.leadingAnchor .constraint(equalTo: safeArea.leadingAnchor),
      questionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      questionView.bottomAnchor  .constraint(equalTo: safeArea.bottomAnchor),
      questionView.heightAnchor  .constraint(equalToConstant: UI.Size.flagQuestionViewHeight)
    ])
  }
  
  // MARK: - Element Control
  
  func setRootViewControllerForBannerView(_ viewController: UIViewController) {
    bannerView.rootViewController = viewController
  }
  
  func loadBannerViewAD() {
    bannerView.load(GADRequest())
  }
  
  func setScoreLabel(text: String) {
    quizStatusView.setScoreLabel(text: text)
  }
  
  func setLeftTopButton(text: String) {
    questionView.setLeftTopButton(text: text)
  }
  
  func setRightTopButton(text: String) {
    questionView.setRightTopButton(text: text)
  }
  
  func setLeftBottomButton(text: String) {
    questionView.setLeftBottomButton(text: text)
  }
  
  func setRightBottomButton(text: String) {
    questionView.setRightBottomButton(text: text)
  }
  
  func setFlagImageView(_ image: UIImage) {
    flagImageView.image = image
  }
  
  func makeAllButtonsEnable(_ enable: Bool) {
    questionView.makeAllButtonsEnable(enable)
  }
  
  func hideFirstLifeImageView(_ hidden: Bool) {
    quizStatusView.hideFirstLifeImageView(hidden)
  }
  
  func hideSecondLifeImageView(_ hidden: Bool) {
    quizStatusView.hideSecondLifeImageView(hidden)
  }
  
  func hideThirdLifeImageView(_ hidden: Bool) {
    quizStatusView.hideThirdLifeImageView(hidden)
  }
  
  func hideFourthLifeImageView(_ hidden: Bool) {
    quizStatusView.hideFourthLifeImageView(hidden)
  }
  
  func hideFifithLifeImageView(_ hidden: Bool) {
    quizStatusView.hideFifithLifeImageView(hidden)
  }
  
  func setCorrectOrIncorrectViewAlpha(_ alpha: CGFloat) {
    correctOrIncorrectView.alpha = alpha
  }
  
  func setCorrectOrIncorrectViewBackgroundColor(_ color: UIColor) {
    correctOrIncorrectView.backgroundColor = color
  }
  
  func setCorrectOrIncorrectLabel(text: String) {
    correctOrIncorrectView.setCorrectOrIncorrectLabel(text: text)
  }
  
}

// MARK: - Question View Delegate

extension FlagQuizView: QuestionViewDelegate {
  func button(_ button: AnswerButton, didTouchUpInsideAt location: ButtonLocation) {
    delegate?.button(button, didTouchUpInsideAt: location)
  }
}

// MARK: - Google AD Banner View Delegate

extension FlagQuizView: GADBannerViewDelegate {
  /// Tells the delegate an ad request loaded an ad.
  func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    print("adViewDidReceiveAd")
    
    bannerView.alpha = 0
    UIView.animate(withDuration: 1, animations: {
      bannerView.alpha = 1
    })
    
    bringSubviewToFront(correctOrIncorrectView)
  }

  /// Tells the delegate an ad request failed.
  func adView(_ bannerView: GADBannerView,
      didFailToReceiveAdWithError error: GADRequestError) {
    print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
  }

  /// Tells the delegate that a full-screen view will be presented in response
  /// to the user clicking on an ad.
  func adViewWillPresentScreen(_ bannerView: GADBannerView) {
    print("adViewWillPresentScreen")
  }

  /// Tells the delegate that the full-screen view will be dismissed.
  func adViewWillDismissScreen(_ bannerView: GADBannerView) {
    print("adViewWillDismissScreen")
  }

  /// Tells the delegate that the full-screen view has been dismissed.
  func adViewDidDismissScreen(_ bannerView: GADBannerView) {
    print("adViewDidDismissScreen")
  }

  /// Tells the delegate that a user click will open another app (such as
  /// the App Store), backgrounding the current app.
  func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
    print("adViewWillLeaveApplication")
  }
}
