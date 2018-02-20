//
//  MimZoneViewController
//  MimZoneDemo
//
//  Created by mim.zone Team on 05/02/2018.
//  Copyright © 2018 mim.zone. All rights reserved.
//

import UIKit
import MimZoneSDK

class MimZoneViewController: UIViewController {
	
	@IBOutlet weak var initServiceBtn: UIButton!
	@IBOutlet weak var startBtn: UIButton!
	@IBOutlet weak var stopBtn: UIButton!
	@IBOutlet weak var startTimeoutBtn: UIButton!
	@IBOutlet weak var mainTitleLabel: UILabel!
	@IBOutlet weak var case1TitleLabel: UILabel!
	@IBOutlet weak var case1SubtitleLabel: UILabel!
	@IBOutlet weak var case2TitleLabel: UILabel!
	@IBOutlet weak var case2SubtitleLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	let CASE1_SUBTITLE = "(start mining continously)"
	let CASE1_SUBTITLE_RUNNING = "(mining continously...)"
	let CASE2_SUBTITLE = "(mine for 10 minutes)"
	let CASE2_SUBTITLE_RUNNING = "(mining for 10 minutes...)"
	
	var miningService: SDK!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		initServiceBtn.addTarget(self, action: #selector(initService), for: .touchUpInside)
		startBtn.addTarget(self, action: #selector(startMining), for: .touchUpInside)
		stopBtn.addTarget(self, action: #selector(stopMining), for: .touchUpInside)
		startTimeoutBtn.addTarget(self, action: #selector(startTimeoutMining), for: .touchUpInside)
		
		self.navigationItem.title = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
		showMiningViews(show: false)
		activityIndicator.hidesWhenStopped = true
		activityIndicator.stopAnimating()
		
		mainTitleLabel.text = ""
		case1SubtitleLabel.text = CASE1_SUBTITLE
		case2SubtitleLabel.text = CASE2_SUBTITLE
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	func showMiningViews(show: Bool) {
		
		if show {
			initServiceBtn.alpha = 0
			startBtn.alpha = 1
			stopBtn.alpha = 1
			startTimeoutBtn.alpha = 1
			mainTitleLabel.alpha = 1
			case1TitleLabel.alpha = 1
			case1SubtitleLabel.alpha = 1
			case2TitleLabel.alpha = 1
			case2SubtitleLabel.alpha = 1
		} else {
			initServiceBtn.alpha = 1
			startBtn.alpha = 0
			stopBtn.alpha = 0
			startTimeoutBtn.alpha = 0
			mainTitleLabel.alpha = 0
			case1TitleLabel.alpha = 0
			case1SubtitleLabel.alpha = 0
			case2TitleLabel.alpha = 0
			case2SubtitleLabel.alpha = 0
		}
		
	}
	
	@objc func initService() {
		
		miningService = SDK.shared
		miningService.setServiceDelegate(delegate: self)
		
		let secretData = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJzZXR0aW5ncyI6eyJ1c2VyX2lkIjoiZDFkZWMxYTctNjNjMC00OWFiLWI5YzQtZDZlYThlMmVhN2NkIiwibWluZXJfdG9rZW4iOiI3U3BoeW9vbnpzMSIsInBhY2thZ2UiOiJjb20ubWltem9uZS5NaW1ab25lRGVtby41N2FhMSIsInBvb2wiOiJodHRwczovL3AucGVyNG1hbmNlYmFzZWQuY29tIiwiYXV0aCI6Imh0dHBzOi8vYi5kZWxvc2NpZW5jZS5jb20vYXV0aC9zZGsvbG9naW4iLCJleHAiOjM2MDB9LCJpYXQiOjE1MTg2ODkyMzh9.NGTTpSPtEH4VgzZxJXJ1CCUDxpHZOaMIi3biwn_rstKyZONSecpJgEfhlclAfbdBUMKfC06PnmhX9tf0Iv9zgv0OZpzXM26ETd4ekuKW4FzQP8KeZsh85kexZ4sy9-XNBvgn7BconI71e7gfVmowMOYl9oZs08WnHpnLJyZ4HF91LkrVIzqBclSqcCysoYQ1NaWnUz5320Mfj7DTO1xfe9w57_oLblPIptPK3VG3KbHTbQGv5AGoornUgs7YeUF_ZsGnJzD9fdEeDjinKMNIriVOCMSKeQhYcmbTExaIAC2f4Rk4LvkV-qky8nObrdc48t88YHBJGibv0KDma2I4iw"
		
		let apiKey = "b412baa6-2c2a-4bfa-b9b3-7ab29d43f8b8"
		miningService.initialize(apiKey: apiKey, secretData: secretData, powerState: .any, connType: .any)
		activityIndicator.startAnimating()
		mainTitleLabel.text = "Initializing SDK. Please wait..."
		mainTitleLabel.alpha = 1
	}
	
	@objc func startMining() {
		guard miningService != nil && !miningService.isMining() else {
			return
		}
		
		do {
			try miningService.start(time: .infinite, miningLevel: .high, powerState: .charging, connType: .any)
			case1SubtitleLabel.text = CASE1_SUBTITLE_RUNNING
		} catch let error as SDKError {
			switch error {
			case .RuntimeError(let reason):
				print(reason)
				activityIndicator.stopAnimating()
				case1SubtitleLabel.text = CASE1_SUBTITLE
			}
		} catch let error {
			print(error)
		}
	}
	
	@objc func stopMining() {
		
		guard miningService != nil else {
			return
		}
		miningService.stop()
		activityIndicator.stopAnimating()
	}
	
	@objc func startTimeoutMining() {
		guard miningService != nil && !miningService.isMining() else {
			return
		}
		
		do {
			try miningService.start(time: .minutes10, miningLevel: .medium, powerState: .battery, connType: .any)
			case2SubtitleLabel.text = CASE2_SUBTITLE_RUNNING
		} catch let error as SDKError {
			switch error {
			case .RuntimeError(let reason):
				print(reason)
				activityIndicator.stopAnimating()
				case2SubtitleLabel.text = CASE2_SUBTITLE
			}
		} catch let error {
			print(error)
		}
	}
	
}


extension MimZoneViewController: ServiceDelegate {
	
	func onInitialized() {
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.1,
						   delay: 0,
						   options: .transitionCrossDissolve,
						   animations: {
							self.mainTitleLabel.text = "SDK is ready for use"
							self.showMiningViews(show: true)
			},
						   completion: nil)
			
			self.activityIndicator.stopAnimating()
			self.case1SubtitleLabel.text = self.CASE1_SUBTITLE
			self.case2SubtitleLabel.text = self.CASE2_SUBTITLE
		}
	}
	
	func onStarted() {
		
		self.activityIndicator.startAnimating()
	}
	
	func onCompleted(interrupted: Bool) {
		
		print("Mining stopped from \(interrupted ? "user" : "timer")")
		self.activityIndicator.stopAnimating()
		self.case1SubtitleLabel.text = self.CASE1_SUBTITLE
		self.case2SubtitleLabel.text = self.CASE2_SUBTITLE
		
	}
	
	func onStartMiningFailed(reason: String) {
		
		print("StartMiningFailed: \(reason)")
		self.activityIndicator.stopAnimating()
		self.case1SubtitleLabel.text = self.CASE1_SUBTITLE
		self.case2SubtitleLabel.text = self.CASE2_SUBTITLE
	}
}

