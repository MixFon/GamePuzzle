//
//  SettingsCubeWrapper.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 12.04.2024.
//

import SwiftUI
import Foundation

struct SettingsCubeWrapper: View {
	
	let model: SettingsCubeModel
	let dependency: _Dependency
	private let factory = SettingsCubeFactory()
	
	var body: some View {
		self.factory.configure(model: self.model, depndecy: self.dependency)
	}
}

extension SettingsCubeWrapper: Equatable {
	static func == (lhs: SettingsCubeWrapper, rhs: SettingsCubeWrapper) -> Bool {
		return true
	}
}
