//
//  TournamentPickerView.swift
//  ALC_RB
//
//  Created by ayur on 29.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol SelectRowTournamentPickerHelper {
    func onSelectRow(row: Int, element: League)
}

class TournamentPickerHelper : NSObject, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    private var rows: [League]?
    private var selectRowProtocol: SelectRowTournamentPickerHelper?
    
    public func setRows (rows: [League]) {
        self.rows = rows
//        dump(rows)
    }
    
    public func setSelectRowPickerHelper(selectRowProtocol: SelectRowTournamentPickerHelper) {
        self.selectRowProtocol = selectRowProtocol
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        Print.m(rows)
        return rows?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel
        
        if let view = view {
            label = view as! UILabel
        }
        else {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 400))
        }
        
        if let rows = rows {
            if let tourney = rows[row].tourney
            {
                if tourney.contains(".")
                {
                    if let name = rows[row].name {
                        label.text = "\(tourney) \(name)"
                    }
                }
                else
                {
                    if let name = rows[row].name {
                        label.text = "\(tourney). \(name)"
                    }
                }
            }
            else
            {
                if let name = rows[row].name {
                    label.text = "\(name)"
                }
            }
        }
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let rows = rows {
//            return rows[row].name
            if let tourney = rows[row].tourney
            {
                if tourney.contains(".")
                {
                    if let name = rows[row].name {
                        return "\(tourney) \(name)"
                    }
                }
                else
                {
                    if let name = rows[row].name {
                        return "\(tourney). \(name)"
                    }
                }
            }
            else
            {
                if let name = rows[row].name {
                    return "\(name)"
                }
            }
        }
        return " <<--->> "
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let rows = rows {
            selectRowProtocol?.onSelectRow(row: row, element: rows[row])
        }
    }
    
}
