//
//  UITableView+Extension.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 18/09/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(with type: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! Cell
    }
}

protocol CursorShowing: AnyObject {
    func showCursor()
}

extension UITableView {
    func cell(after cell: UITableViewCell) -> UITableViewCell? {
        guard let indexPath = indexPath(for: cell) else {
            assertionFailure("The cell passed is not in this table view")
            return nil
        }
        let currentSection = indexPath.section
        let rowsCount = numberOfRows(inSection: currentSection)
        let currentRow = indexPath.row
        let shouldGoToNextSection = currentRow == rowsCount - 1
        let nextRow = shouldGoToNextSection ? 0 : currentRow + 1
        let nextSection: Int
        if shouldGoToNextSection {
            nextSection = (currentSection == numberOfSections - 1) ? 0 : currentSection + 1
        } else {
            nextSection = currentSection
        }
        return cellForRow(at: IndexPath(row: nextRow, section: nextSection))
    }
    
    func showCursorInCell(after cell: UITableViewCell) {
        var nextCell: CursorShowing?
        repeat {
            nextCell = self.cell(after: cell) as? CursorShowing
        } while nextCell == nil
        nextCell?.showCursor()
    }
}
