//
//  ContentView.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 20.02.2024.
//

import SwiftUI
import SceneKit
import MFPuzzle

struct MenuView: View {
	
	private let size = 4
	private let matrixWorker = MatrixWorker()
	
	@State private var toStart: Bool = false
	@State private var toOprionts: Bool = false
	
	var body: some View {
		MenuSceneWrapper(toStart: $toStart, toOprionts: $toOprionts)
			.fullScreenCover(isPresented: self.$toStart) {
				StartView()
			}
			.fullScreenCover(isPresented: self.$toOprionts) {
				OptionsView()
			}
			.edgesIgnoringSafeArea(.all)
	}
}

#Preview {
    MenuView()
}
