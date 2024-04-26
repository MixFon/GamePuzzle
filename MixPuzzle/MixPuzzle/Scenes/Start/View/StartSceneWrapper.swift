//
//  StartSceneWrapper.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 05.04.2024.
//

import SwiftUI
import Foundation

struct StartSceneWrapper: View {
    let dependency: _Dependency
	
	private let startFactory = StartFactory()
	
	var body: some View {
        self.startFactory.configure(dependency: self.dependency)
	}
}

extension StartSceneWrapper: Equatable {
	static func == (lhs: StartSceneWrapper, rhs: StartSceneWrapper) -> Bool {
		return true
	}
}
