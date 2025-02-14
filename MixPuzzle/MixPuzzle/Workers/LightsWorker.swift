//
//  LightsWorker.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 29.12.2024.
//

import SceneKit
import Foundation

/// Протокол описывающий взаимодествия с источниками света
protocol _LightsWorker {
	func setupLights(center: SCNVector3, radius: Float, rootNode: SCNNode)
}

final class LightsWorker: _LightsWorker {
	
	private let rotationWorker: _RotationWorker
	
	private let radiusSunNode: Float = 2
	private let radiusLightNode: Float = 2
	
	private lazy var lightNode: SCNNode = {
		let lightNode = SCNNode()
		lightNode.light = SCNLight()
		lightNode.light?.type = .omni
		
		let sphere = SCNSphere(radius: CGFloat(self.radiusSunNode))
		let sphereMaterial = SCNMaterial()
		sphereMaterial.diffuse.contents = UIColor.white // Цвет шара.
		sphereMaterial.emission.contents = UIColor.white
		sphere.materials = [sphereMaterial]
		lightNode.geometry = sphere
		
		lightNode.position = SCNVector3(x: 0, y: 0, z: 0)

		return lightNode
	}()
	
	private lazy var sunNode: SCNNode = {
		let sunNode = SCNNode()
		sunNode.light = SCNLight()
		sunNode.light?.type = .omni
		
		let sphere = SCNSphere(radius: CGFloat(self.radiusSunNode))
		let sphereMaterial = SCNMaterial()
		sphereMaterial.diffuse.contents = UIColor.white
		sphereMaterial.emission.contents = UIColor.white
		sphere.materials = [sphereMaterial]
		sunNode.geometry = sphere
		
		sunNode.position = SCNVector3(x: 0, y: 0, z: 0)

		return sunNode
	}()
	
	private let ambientLightNode: SCNNode = {
		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light?.type = .ambient
		ambientLightNode.light?.color = UIColor.darkGray.cgColor
		return ambientLightNode
	}()
	
	init(rotationWorker: _RotationWorker) {
		self.rotationWorker = rotationWorker
	}
	
	func setupLights(center: SCNVector3, radius: Float, rootNode: SCNNode) {
		self.rotationWorker.createRotation(
			node: self.lightNode,
			rootNode: rootNode,
			centerOrbit: center
		)
		
		self.rotationWorker.createRotation(
			node: self.sunNode,
			rootNode: rootNode,
			centerOrbit: center
		)
		let delta: Float = 2
		setPositionToRadiusMatrix(node: self.lightNode, radius: radius + self.radiusLightNode + delta)
		setPositionToRadiusMatrix(node: self.sunNode, radius: radius + self.radiusLightNode + self.radiusSunNode + delta)
	}
	
	/// Устанавливает позицию Node на радиусе сферы описаной, около матрицы
	/// - node: устанавливаемый узел
	/// - radius: радиус сферы на которой нужно назместить node
	private func setPositionToRadiusMatrix(node: SCNNode, radius: Float) {
		// Генерация случайных углов
		let theta = Float.random(in: 0...2 * Float.pi) // Азимутальный угол (0 до 2π)
		let phi = acos(2 * Float.random(in: 0...1) - 1) // Полярный угол (0 до π)
		
		// Перевод сферических координат в декартовы
		let x = radius * sin(phi) * cos(theta)
		let y = radius * sin(phi) * sin(theta)
		let z = radius * cos(phi)
		node.position = SCNVector3(x: x, y: y, z: z)
	}
}

final class MockLightsWorker: _LightsWorker {
	func setupLights(center: SCNVector3, radius: Float, rootNode: SCNNode) {
		debugPrint(#function)
	}
}
