//
//  StartFactory.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 01.03.2024.
//

import SwiftUI
import MFPuzzle
import Foundation

final class StartFactory {
	
	func configure(dependency: _Dependency, startSceneModel: StartSceneModel) -> some View {
		
		dependency.workers.gameWorker.updateMatrix()
		let matrix = dependency.workers.gameWorker.matrix
		let grid = Grid(matrix: matrix)
		let boxWorker = BoxesWorker(
			grid: grid,
			cubeWorker: dependency.workers.cubeWorker,
			settingsCubeStorate: dependency.settingsStorages.settingsCubeStorage
		)
		let startScene = StartScene(
			boxWorker: boxWorker,
			generator: dependency.settingsStorages.settingsGameStorage.isUseVibration ? UINotificationFeedbackGenerator() : nil,
			gameWorker: dependency.workers.gameWorker,
			lightsWorker: dependency.workers.lightsWorker,
			rotationWorker: dependency.workers.rotationWorker,
			asteroidWorker: dependency.workers.asteroidWorker,
			textNodeWorker: dependency.workers.textNodeWorker,
			startSceneModel: startSceneModel,
			notificationCenter: NotificationCenter.default
		)
		startScene.settings.isShowAsteroids = dependency.settingsStorages.settingsAsteroidsStorage.isShowAsteroids
		return startScene
	}
	
	/// Создает сцену по матрице, только для отображения, тут небудет реакции на движения, текста и игры
	func configure(matrix: Matrix, dependency: _Dependency) -> some View {
		let grid = Grid(matrix: matrix)
		let boxWorker = BoxesWorker(
			grid: grid,
			cubeWorker: dependency.workers.cubeWorker,
			settingsCubeStorate: dependency.settingsStorages.settingsCubeStorage
		)
		let startScene = StartScene(
			boxWorker: boxWorker,
			generator: nil,
			gameWorker: MockGameWorker(),
			lightsWorker: LightsWorker(rotationWorker: dependency.workers.rotationWorker),
			rotationWorker: dependency.workers.rotationWorker,
			asteroidWorker: dependency.workers.asteroidWorker,
			textNodeWorker: MockTextNodeWorker(),
			startSceneModel: nil
		)
		startScene.settings.isUserInteractionEnabled = false
		return startScene
	}
	
	/// Создает сцену для показа ходов решения. В ней отключены перемещения элементов
	func configureShowPathCompasses(matrix: Matrix, dependency: _Dependency, startSceneModel: StartSceneModel) -> some View {
		let grid = Grid(matrix: matrix)
		let boxWorker = BoxesWorker(
			grid: grid,
			cubeWorker: dependency.workers.cubeWorker,
			settingsCubeStorate: dependency.settingsStorages.settingsCubeStorage
		)
		let startScene = StartScene(
			boxWorker: boxWorker,
			generator: nil,
			gameWorker: dependency.workers.gameWorker,
			lightsWorker: dependency.workers.lightsWorker,
			rotationWorker: dependency.workers.rotationWorker,
			asteroidWorker: dependency.workers.asteroidWorker,
			textNodeWorker: dependency.workers.textNodeWorker,
			startSceneModel: startSceneModel
		)
		startScene.settings.isMoveOn = false
		startScene.settings.isShowAsteroids = dependency.settingsStorages.settingsAsteroidsStorage.isShowAsteroids
		return startScene
	}
}
