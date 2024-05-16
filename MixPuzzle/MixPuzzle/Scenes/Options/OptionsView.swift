//
//  OptionsView.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 24.02.2024.
//

import SwiftUI

final class OptionsViewRouter: ObservableObject {
	@Published var toBox: Bool = false
	@Published var toGame: Bool = false
	@Published var toStars: Bool = false
	@Published var toLanguage: Bool = false
	@Published var toVibration: Bool = false
}

struct OptionsView: View {
    
	let dependency: _Dependency
	
	@ObservedObject private var router = OptionsViewRouter()
	
	@State private var isOnVibration: Bool = false
	
	var body: some View {
		VStack {
			NavigationBar(title: "Options")
				.padding()
			OptionsSectionsView(title: "Garaphics", cells: [
				AnyView(CellView(icon: "cube", text: "Cube", action: { self.router.toBox = true })),
				AnyView(CellView(icon: "moon.stars", text: "Asteroids", action: { self.router.toStars = true })),
			])
			.padding()
			OptionsSectionsView(title: "Application", cells: [
				AnyView(CellView(icon: "globe", text: "Language", action: { self.router.toLanguage = true })),
				AnyView(ToggleCellView(icon: "waveform.path", text: "Vibration", isOn: $isOnVibration)),
			])
			.padding()
			OptionsSectionsView(title: "Game", cells: [
				AnyView(CellView(icon: "gamecontroller", text: "Game", action: { self.router.toGame = true })),
				AnyView(CellView(icon: "chart.bar.xaxis", text: "Statistics", action: {  })),
			])
			.padding()
			Spacer()
		}
		.background(Color.mm_background_secondary)
		.fullScreenCover(isPresented: $router.toBox) {
			SettingsCubeView(dependency: self.dependency, model: SettingsCubeModel(cubeStorage: self.dependency.settingsStorages.settingsCubeStorage))
		}
		.fullScreenCover(isPresented: $router.toStars) {
			SettingsAsteroids(asteroidsModel: SettingsAsteroidsModel(asteroidsStorage: self.dependency.settingsStorages.settingsAsteroidsStorage))
		}
		.fullScreenCover(isPresented: $router.toGame) {
			SettingsGameView(gameModel: SettingsGameModel(gameStorage: self.dependency.settingsStorages.settingsGameStorage))
		}
	}
}

#Preview {
    OptionsView(dependency: MockDependency())
}

final class MockSettingsStorage: _SettingsStorage {
	var settingsGameStorage: _SettingsGameStorage = MockSettingsGameStorage()
    var settingsCubeStorage: _SettingsCubeStorage = MockSettingsCubeStorage()
    var settingsAsteroidsStorage: _SettingsAsteroidsStorage = MockSettingsAsteroidsStorage()
}
