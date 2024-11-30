//
//  TargetSelectionView.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 17.05.2024.
//

import SwiftUI
import MFPuzzle

final class TargetSelectionModel: ObservableObject {
	@Published var selectedSolution: Solution
	
	private var gameWorker: _GameWorker
	
	init(gameWorker: _GameWorker) {
		self.gameWorker = gameWorker
		self.selectedSolution = gameWorker.solution
	}
	
	func saveChanges() {
		self.gameWorker.save(solution: self.selectedSolution)
	}
}

struct TargetSelectionView: View {
	private let dependncy: _Dependency
	private let solutionOptions: [MatrixSolution]
	
	@ObservedObject
	private var model: TargetSelectionModel
	
	@State
	private var isShowSnackbar = false
	
	init(dependncy: _Dependency) {
		self.dependncy = dependncy
		self.solutionOptions = self.dependncy.workers.gameWorker.solutionOptions
		self.model = TargetSelectionModel(gameWorker: dependncy.workers.gameWorker)
	}
	
    var body: some View {
		VStack {
			NavigationBar(
				title: "Target selection",
				tralingView: AnyView(
					SaveButtonNavigationBar(
						action: {
							self.model.saveChanges()
							self.isShowSnackbar = true
						}
					)
				)
			)
			.padding()
			ScrollView {
				ForEach(solutionOptions, id: \.type) { option in
					Button {
						self.model.selectedSolution = option.type
					} label: {
						TargetView(option: option, dependncy: self.dependncy, isSelected: option.type == self.model.selectedSolution)
					}
					.padding()
					.buttonStyle(.plain)
				}
			}
		}
		.snackbar(isShowing: $isShowSnackbar, text: "The data has been saved successfully.", style: .success, extraBottomPadding: 16)
		.background(Color.mm_background_tertiary)
    }
}

struct TargetView: View {
	let option: MatrixSolution
	let dependncy: _Dependency
	let isSelected: Bool
	
	private let radius: CGFloat = 20
	var body: some View {
		VStack {
			TargetSelectSceneWrapper(matrix: option.matrix, dependency: dependncy)
				.aspectRatio(contentMode: .fit)
				.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
				.overlay(
					RoundedRectangle(cornerRadius: radius)
						.stroke(Color.blue, lineWidth: isSelected ? 3 : 0)
				)
			Text(option.type.description)
		}
	}
}

#Preview {
	let mockDependecy = MockDependency()
	return TargetSelectionView(dependncy: mockDependecy)
}

