//
//  BoxesWorker.swift
//  MixPuzzle
//
//  Created by Михаил Фокин on 25.02.2024.
//

import MFPuzzle
import SceneKit

protocol _StartWorker {
    func crateMatrixBox() -> [SCNNode]
    func calculateCameraPosition() -> SCNVector3
	func createMoveToZeroAction(number: UInt8) -> SCNAction?
}

/// Занимается созданием и UI настройкой матрицы элементов. Так же отвечает за пермещение элементов
final class BoxesWorker: _StartWorker {
	/// Модель сетки, на основе нее строится отобрадение
	private let grid: Grid
    private let lengthEdge: CGFloat = 4
    private let verticalPadding: CGFloat = 0.4
	/// Длительность анимации передвижения в позицию 0
	private let animationDuration: TimeInterval = 0.3
    private let horisontalPadding: CGFloat = 0.2
    
    private struct Box {
		let point: Point
        let number: Int
        let lengthEdge: CGFloat
		
		struct Point {
			let x: CGFloat
			let y: CGFloat
		}
    }
    
    init(grid: Grid) {
        self.grid = grid
    }

    func crateMatrixBox() -> [SCNNode] {
        return createNodesFormMatrix(matrix: self.grid.matrix)
    }
    
    func calculateCameraPosition() -> SCNVector3 {
		let centreX = CGFloat(self.grid.size) * (self.lengthEdge + self.horisontalPadding) - self.horisontalPadding - self.lengthEdge
		let centreY = CGFloat(self.grid.size) * (self.lengthEdge + self.verticalPadding) - self.verticalPadding - self.lengthEdge
		let height = CGFloat(self.grid.size) * (self.lengthEdge + self.horisontalPadding) + CGFloat(self.grid.size) * self.lengthEdge * 0.85
        return SCNVector3(x: Float(centreX / 2), y: Float(-centreY / 2), z: Float(height))
    }
	
	func createMoveToZeroAction(number: UInt8) -> SCNAction? {
		guard self.grid.isNeighbors(one: number, two: 0) == true else { return nil }
		guard let pointZero = self.grid.getPoint(number: 0) else { return nil }
		let boxPointZero = getBoxPoint(i: Int(pointZero.x), j: Int(pointZero.y))
		// Для векторов SCNVector3 на первом месте тоит Y на втором -X координаты из матрицы
		let action = SCNAction.move(to: SCNVector3(x: Float(boxPointZero.y), y: Float(-boxPointZero.x), z: 0), duration: self.animationDuration)
		self.grid.swapNumber(number: number)
		return action
	}
	
	private func getBoxPoint(i: Int, j: Int) -> Box.Point {
		let verticalEdge = self.lengthEdge + self.verticalPadding
		let horisontalEdge = self.lengthEdge + self.horisontalPadding
		let point = Box.Point(
			x: CGFloat(i) * verticalEdge,
			y: CGFloat(j) * horisontalEdge
		)
		return point
	}
	
    private func createNodesFormMatrix(matrix: Matrix) -> [SCNNode] {
        var nodes = [SCNNode]()
        for (i, line) in matrix.enumerated() {
            for (j, number) in line.enumerated() {
                if number == 0 { continue }
                let box = Box(
					point: getBoxPoint(i: i, j: j),
                    number: Int(number),
                    lengthEdge: lengthEdge
                )
                let node = getBox(box: box)
                nodes.append(node)
            }
        }
        return nodes
    }
    
    private func getBox(box: Box) -> SCNNode {
        let boxNode = SCNNode()
        let lengthEdge = box.lengthEdge
        boxNode.geometry = SCNBox(width: lengthEdge, height: lengthEdge, length: lengthEdge, chamferRadius: 1)
		let name = "\(box.number)"
		boxNode.name = name
        //let im = UIImage(systemName: "\(box.number).circle.fill")
        let im = imageWith(name: name)
        
        let material = SCNMaterial()
        // Является базой для поверхности
        material.diffuse.contents = im
        
        // Отвечат за металический отблеск
        material.specular.contents = UIImage(named: "bubble", in: nil, with: nil)
        
        // Отвечает за зеркальный отблеск, в отражени будут обекты, переданные в contents
        //material.reflective.contents = UIImage(named: "bubble", in: nil, with: nil)
        
        // Используется для затемнения или тонирования. Можно использовать как теневую карту
        //material.multiply.contents = im
        
        // Можно имитировать облака
        //material.transparent.contents = UIImage(named: "bubble", in: nil, with: nil)
        //material.ambient.contents =
        
        boxNode.geometry?.firstMaterial = material
		boxNode.position = SCNVector3(box.point.y, -box.point.x, 0)
        return boxNode
    }
    
    /// Создание изображения по тексту. Создает текст в круге.
    private func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .blue
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.text = name
        nameLabel.layer.cornerRadius = 10
        nameLabel.layer.masksToBounds = true
        let viewFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .red
        view.addSubview(nameLabel)
        UIGraphicsBeginImageContext(viewFrame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            view.layer.render(in: currentContext)
            let view = UIGraphicsGetImageFromCurrentImageContext()
            return view
        }
        return nil
    }

}
