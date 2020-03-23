//
//  AppDelegate.swift
//  StringifyExample
//
//  Created by Anton Novichenko on 3/22/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
		let navigationController = UINavigationController(rootViewController: viewController)

		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()

		return true
	}
}

