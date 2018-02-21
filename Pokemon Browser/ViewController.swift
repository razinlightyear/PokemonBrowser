//
//  ViewController.swift
//  Pokemon Browser
//
//  Created by Andrew Emrazian on 2/20/18.
//  Copyright © 2018 Andrew Emrazian. All rights reserved.
//

import Cocoa

func dialogOKCancel(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    return alert.runModal() == .alertFirstButtonReturn
}

class ViewController: NSViewController {

    @IBOutlet weak var pokemonNameField: NSTextFieldCell!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var idLabel: NSTextField!
    @IBOutlet weak var weightLabel: NSTextField!
    @IBOutlet weak var heightLabel: NSTextFieldCell!
    @IBOutlet weak var baseExperienceLabel: NSTextField!
    @IBOutlet weak var typesLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func updateLabels(name: String, data: Data) {
        do {
            let pokemonData = try JSONDecoder().decode(Pokemon.self, from: data)
            print(pokemonData.id)
            print(pokemonData.name)
            DispatchQueue.main.async {
                self.nameLabel.stringValue = pokemonData.name.capitalized
                self.idLabel.stringValue = String(pokemonData.id)
                
                // Weight/ height returned ints are really doubles divided by 10 (as kilograms)
                var weightStr = String(pokemonData.weight)
                weightStr.insert(".", at: weightStr.index(before: weightStr.endIndex))
                self.weightLabel.stringValue = weightStr
                
                var heightStr = String(pokemonData.height)
                heightStr.insert(".", at: heightStr.index(before: heightStr.endIndex))
                self.heightLabel.stringValue = heightStr
                
                self.baseExperienceLabel.stringValue = String(pokemonData.baseExperience)
                
                var typesStr = ""
                for type in pokemonData.types {
                    typesStr.append(type.type.name + "\n")
                }
                self.typesLabel.stringValue = typesStr
            }
        } catch let jsonError {
            print(jsonError)
            DispatchQueue.main.async {
                dialogOKCancel(question: "Not Found", text: "Pokemon with \(name) could not be found")
            }
        }
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        var name = pokemonNameField.stringValue
        if name.isEmpty {
            name = "bulbasaur"
        }
        // Call out to the Poke API
        let urlString = "http://pokeapi.co/api/v2/pokemon/\(name.lowercased())"
        print(urlString)
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            self.updateLabels(name: name, data: data)
            
        }.resume()
        
//        let image = NSImage(byReferencing:NSURL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png")! as URL)
//        let imageView = NSImageView()
//        imageView.image = image
    }
    
}

