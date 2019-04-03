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
    }
    
    public func setSelectRowPickerHelper(selectRowProtocol: SelectRowTournamentPickerHelper) {
        self.selectRowProtocol = selectRowProtocol
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rows?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let rows = rows {
            return rows[row].name
        }
        return " <<--->> "
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let rows = rows {
            selectRowProtocol?.onSelectRow(row: row, element: rows[row])
        }
    }
    
}
