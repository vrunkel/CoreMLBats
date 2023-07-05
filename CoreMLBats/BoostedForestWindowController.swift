//
//  BoostedForestWindowController.swift
//  CoreMLBats
//
//  Created by Volker Runkel on 04.07.23.
//  Copyright © 2023 Volker Runkel. All rights reserved.
//

import Cocoa
import CoreML
import CreateML

class BoostedForestWindowController: NSWindowController {

    @IBOutlet weak var inputFileField: NSTextField!
    @IBOutlet weak var modelSelector: NSPopUpButton!
    @IBOutlet weak var resultTable: NSTableView!
    
    var results = Array<(String, Double)>()
    let percentFormatter = NumberFormatter()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.percentFormatter.numberStyle = .percent
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func importCSV(_ sender: Any) {
        let op = NSOpenPanel()
        op.allowedFileTypes = ["csv","batIdent2"]
        op.allowsMultipleSelection = false
        op.begin { response in
            if response == .OK, let url = op.url{
                // load data
                
                self.inputFileField.stringValue = url.lastPathComponent
                
                guard  var textString = try? String(contentsOf: url) else {
                    return
                }
                
                let decimalSep = textString.determineDecimalSeparator()
                let columnSep = textString.determineColumnSeparator()
                
                if columnSep != "," && decimalSep == "," {
                    textString = textString.replacingOccurrences(of: ",", with: ".")
                }
                
                self.results.removeAll()
                
                let parsingOption = MLDataTable.ParsingOptions(containsHeader: true, delimiter: columnSep ?? ",")
                if let tableData = try? MLDataTable(contentsOf: url, options: parsingOption) {
                    //print(tableData)
                    if self.modelSelector.indexOfSelectedItem == 0 {
                        if let tabularClassifier = try? BatCallTabularClassifier_bT(configuration: MLModelConfiguration()) {
                            for aRow in tableData.rows {
                                if let output = try? tabularClassifier.prediction(Dur: aRow["Dur"]!.doubleValue!, Sfreq: aRow["Sfreq"]!.doubleValue!, Efreq: aRow["Efreq"]!.doubleValue!, Stime: aRow["Stime"]!.doubleValue!, NMod: aRow["NMod"]!.doubleValue!, FMod: aRow["FMod"]!.doubleValue!, FRmin: aRow["FRmin"]!.doubleValue!, Rmin: aRow["Rmin"]!.doubleValue!, tRmin: aRow["tRmin"]!.doubleValue!, Rlastms: aRow["Rlastms"]!.doubleValue!, Flastms: aRow["Flastms"]!.doubleValue!, Fknee: aRow["Fknee"]!.doubleValue!, Alphaknee: aRow["Alphaknee"]!.doubleValue!, Rknee: aRow["Rknee"]!.doubleValue!, ptknee: aRow["ptknee"]!.doubleValue!, Fmk: aRow["Fmk"]!.doubleValue!, Alphamk: aRow["Alphamk"]!.doubleValue!, Rmk: aRow["Rmk"]!.doubleValue!, ptmk: aRow["ptmk"]!.doubleValue!, Fmed: aRow["Fmed"]!.doubleValue!, Fmidt: aRow["Fmidt"]!.doubleValue!, Fmidf: aRow["Fmidf"]!.doubleValue!, tmidf: aRow["tmidf"]!.doubleValue!, ptmidf: aRow["ptmidf"]!.doubleValue!, PFmidt: aRow["PFmidt"]!.doubleValue!, Rmidt: aRow["Rmidt"]!.doubleValue!, Rmed: aRow["Rmed"]!.doubleValue!, Rges: aRow["Rges"]!.doubleValue!, Dfm: aRow["Dfm"]!.doubleValue!, Dqcf: aRow["Dqcf"]!.doubleValue!) {
                                    //print(output.Gruppe)
                                    //print(output.GruppeProbability[output.Gruppe])
                                    self.results.append((output.Gruppe,output.GruppeProbability[output.Gruppe]!))
                                }
                            }
                        }
                    } else if self.modelSelector.indexOfSelectedItem == 1 {
                        if let tabularClassifier = try? BatCallTabularClassifier_rF(configuration: MLModelConfiguration()) {
                            for aRow in tableData.rows {
                                if let output = try? tabularClassifier.prediction(Dur: aRow["Dur"]!.doubleValue!, Sfreq: aRow["Sfreq"]!.doubleValue!, Efreq: aRow["Efreq"]!.doubleValue!, Stime: aRow["Stime"]!.doubleValue!, NMod: aRow["NMod"]!.doubleValue!, FMod: aRow["FMod"]!.doubleValue!, FRmin: aRow["FRmin"]!.doubleValue!, Rmin: aRow["Rmin"]!.doubleValue!, tRmin: aRow["tRmin"]!.doubleValue!, Rlastms: aRow["Rlastms"]!.doubleValue!, Flastms: aRow["Flastms"]!.doubleValue!, Fknee: aRow["Fknee"]!.doubleValue!, Alphaknee: aRow["Alphaknee"]!.doubleValue!, Rknee: aRow["Rknee"]!.doubleValue!, ptknee: aRow["ptknee"]!.doubleValue!, Fmk: aRow["Fmk"]!.doubleValue!, Alphamk: aRow["Alphamk"]!.doubleValue!, Rmk: aRow["Rmk"]!.doubleValue!, ptmk: aRow["ptmk"]!.doubleValue!, Fmed: aRow["Fmed"]!.doubleValue!, Fmidt: aRow["Fmidt"]!.doubleValue!, Fmidf: aRow["Fmidf"]!.doubleValue!, tmidf: aRow["tmidf"]!.doubleValue!, ptmidf: aRow["ptmidf"]!.doubleValue!, PFmidt: aRow["PFmidt"]!.doubleValue!, Rmidt: aRow["Rmidt"]!.doubleValue!, Rmed: aRow["Rmed"]!.doubleValue!, Rges: aRow["Rges"]!.doubleValue!, Dfm: aRow["Dfm"]!.doubleValue!, Dqcf: aRow["Dqcf"]!.doubleValue!, Typ: aRow["Typ"]!.doubleValue!, X10: aRow["X10"]!.doubleValue!, X11: aRow["X11"]!.doubleValue!, X12: aRow["X12"]!.doubleValue!, X13: aRow["X13"]!.doubleValue!, X14: aRow["X14"]!.doubleValue!, X15: aRow["X15"]!.doubleValue!, X16: aRow["X16"]!.doubleValue!, X17: aRow["X17"]!.doubleValue!, X18: aRow["X18"]!.doubleValue!, X19: aRow["X19"]!.doubleValue!, X20: aRow["X20"]!.doubleValue!, X21: aRow["X21"]!.doubleValue!, X22: aRow["X22"]!.doubleValue!, X23: aRow["X23"]!.doubleValue!, X24: aRow["X24"]!.doubleValue!, X25: aRow["X25"]!.doubleValue!, X26: aRow["X26"]!.doubleValue!, X27: aRow["X27"]!.doubleValue!, X28: aRow["X28"]!.doubleValue!, X29: aRow["X29"]!.doubleValue!, X30: aRow["X30"]!.doubleValue!, X31: aRow["X31"]!.doubleValue!, X32: aRow["X32"]!.doubleValue!, X33: aRow["X33"]!.doubleValue!, X34: aRow["X34"]!.doubleValue!, X35: aRow["X35"]!.doubleValue!, X36: aRow["X36"]!.doubleValue!, X37: aRow["X37"]!.doubleValue!, X38: aRow["X38"]!.doubleValue!, X39: aRow["X39"]!.doubleValue!, X40: aRow["X40"]!.doubleValue!, X41: aRow["X41"]!.doubleValue!, X42: aRow["X42"]!.doubleValue!, X43: aRow["X43"]!.doubleValue!, X44: aRow["X44"]!.doubleValue!, X45: aRow["X45"]!.doubleValue!, X46: aRow["X46"]!.doubleValue!, X47: aRow["X47"]!.doubleValue!, X48: aRow["X48"]!.doubleValue!, X49: aRow["X49"]!.doubleValue!, X50: aRow["X50"]!.doubleValue!, X51: aRow["X51"]!.doubleValue!, X52: aRow["X52"]!.doubleValue!, X53: aRow["X53"]!.doubleValue!, X54: aRow["X54"]!.doubleValue!, X55: aRow["X55"]!.doubleValue!, X56: aRow["X56"]!.doubleValue!, X57: aRow["X57"]!.doubleValue!, X58: aRow["X58"]!.doubleValue!, X59: aRow["X59"]!.doubleValue!, X60: aRow["X60"]!.doubleValue!, X62: aRow["X62"]!.doubleValue!, X64: aRow["X64"]!.doubleValue!, X66: aRow["X66"]!.doubleValue!, X68: aRow["X68"]!.doubleValue!, X70: aRow["X70"]!.doubleValue!, X72: aRow["X72"]!.doubleValue!, X74: aRow["X74"]!.doubleValue!, X76: aRow["X76"]!.doubleValue!, X78: aRow["X78"]!.doubleValue!, X80: aRow["X80"]!.doubleValue!, X82: aRow["X82"]!.doubleValue!, X84: aRow["X84"]!.doubleValue!, X86: aRow["X86"]!.doubleValue!, X88: aRow["X88"]!.doubleValue!, X90: aRow["X90"]!.doubleValue!, X92: aRow["X92"]!.doubleValue!, X94: aRow["X94"]!.doubleValue!, X96: aRow["X96"]!.doubleValue!, X98: aRow["X98"]!.doubleValue!, X100: aRow["X100"]!.doubleValue!, X102: aRow["X102"]!.doubleValue!, X104: aRow["X104"]!.doubleValue!, X106: aRow["X106"]!.doubleValue!, X108: aRow["X108"]!.doubleValue!, X110: aRow["X110"]!.doubleValue!, X112: aRow["X112"]!.doubleValue!, X114: aRow["X114"]!.doubleValue!, X116: aRow["X116"]!.doubleValue!, X118: aRow["X118"]!.doubleValue!, X120: aRow["X120"]!.doubleValue!, X122: aRow["X122"]!.doubleValue!, X124: aRow["X124"]!.doubleValue!, X126: aRow["X126"]!.doubleValue!, X128: aRow["X128"]!.doubleValue!, X130: aRow["X130"]!.doubleValue!, X132: aRow["X132"]!.doubleValue!, X134: aRow["X134"]!.doubleValue!, X136: aRow["X136"]!.doubleValue!, X138: aRow["X138"]!.doubleValue!, X140: aRow["X140"]!.doubleValue!, X142: aRow["X142"]!.doubleValue!, X144: aRow["X144"]!.doubleValue!, X146: aRow["X146"]!.doubleValue!, X148: aRow["X148"]!.doubleValue!) {
                                    //print(output.Gruppe)
                                    //print(output.GruppeProbability[output.Gruppe])
                                    self.results.append((output.Gruppe,output.GruppeProbability[output.Gruppe]!))
                                }
                            }
                        }
                    }
                    self.resultTable.reloadData()
                }
                
            }
        }
    }
    
}

extension BoostedForestWindowController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if self.results.count <= row {
            return nil
        }
        
        var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MyView"), owner: self)
        if cell == nil {
            cell = NSTableCellView(frame: NSMakeRect(0,0,45,24))
            cell?.identifier = NSUserInterfaceItemIdentifier(rawValue: "MyView")
            cell?.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.width.rawValue | NSView.AutoresizingMask.height.rawValue)
            let cellText = NSTextField(frame: NSMakeRect(0,4,45,20))
            cellText.isBezeled = false
            cellText.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
            cellText.autoresizingMask = NSView.AutoresizingMask(rawValue: NSView.AutoresizingMask.width.rawValue | NSView.AutoresizingMask.height.rawValue)
            cellText.drawsBackground = false
            cellText.alignment = NSTextAlignment.left
            cellText.isEditable = false
            cellText.isSelectable = false
            
            cell?.addSubview(cellText)
            (cell as! NSTableCellView).textField = cellText
        }
        //let contents = self.dataArray![row][tableView.tableColumns.firstIndex(of: tableColumn!)!]
        if tableColumn?.identifier.rawValue == "groupColumn" {
            (cell as! NSTableCellView).textField!.stringValue = self.results[row].0
        } else if tableColumn?.identifier.rawValue == "probColumn" {
            (cell as! NSTableCellView).textField!.stringValue = self.percentFormatter.string(from: NSNumber(value:self.results[row].1)) ?? "---"
        }
        
        return cell;
    }
    
}
