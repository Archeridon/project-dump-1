//
//  ViewController.swift
//  finals
//
//  Created by Student on 12/19/16.
//  Copyright © 2016 Archeridon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var startingCover: UILabel!
    
    @IBOutlet weak var hidelabel: UILabel!
    @IBOutlet weak var hidelabel1: UILabel!
    @IBOutlet weak var hidelabel2: UILabel!
    
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var nameTextfeild: UITextField!
    
    
    @IBOutlet weak var endedBattleView: UIView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var enemyName: UILabel!
    
    @IBOutlet weak var characterHpLabel: UILabel!
    
    @IBOutlet weak var enemyHpLabel: UILabel!
    @IBOutlet weak var expWonLabel: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var carryonOutlet: UIButton!
    
    var mobList = ["Slime", "Bandit", "Tree"]
    var currentHP = 20
    var mobHP = 10
    var mobCurrent = 10
    var level = 1
    var levelreq = Int()
    var enemyDamage = 1
    var exp = 0
    var name = String()
    
    var characterAttack = false
    var monsterAttack = false
    var battle = false
    var battlefiller = false
    var okayToClick = true
    var attack = false
    var double = false
    var heal = false
    var deadenemy = false
    
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.userDefault.value(forKey: "Level") != nil) {
            level = self.userDefault.value(forKey: "Level") as! NSInteger
        }
        if(self.userDefault.value(forKey: "Exp") != nil) {
            exp = self.userDefault.value(forKey: "Level") as! NSInteger
        }
        if(self.userDefault.value(forKey: "Name") != nil) {
            name = self.userDefault.value(forKey: "Name") as! NSString as String
        }
        if(self.userDefault.value(forKey: "CurrentHP") != nil) {
            currentHP = self.userDefault.value(forKey: "CurrentHP") as! NSInteger
        }
        characterName.text = "\(name) Lv.\(level)"
        if name == ""
        {
        }
        else {
            hidelabel.isHidden = true
            hidelabel1.isHidden = true
            hidelabel2.isHidden = true
            startingCover.isHidden = true
            nameTextfeild.isHidden = true
            startButtonOutlet.isHidden = true
        }
        
        endedBattleView.isHidden = true
        carryonOutlet.isHidden = true
        battleStart()
        
        
        image1.image = UIImage(named: "character")
       
        timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(ViewController.animation), userInfo: nil, repeats: true)
       
    }
    ///End View did load

    func animation()
    {
        //reset things
        if battle == false {
            image4.isHidden = false
            image2.isHidden = true
        }
        if deadenemy == true {
            battleStart()
            timer.invalidate()
            deadenemy = false
            battle = false
            endedBattleView.isHidden = false
            exp = exp + 1
            self.userDefault.setValue(exp, forKey: "Exp")
            self.userDefault.synchronize()
            levelreq = 2*(level - 1) + 1
            carryonOutlet.isHidden = false
            if exp == levelreq
            {
                level = level + 1
                expWonLabel.text = "Gained exp and leveled up to level \(level)"
                self.userDefault.setValue(level, forKey: "Level")
                self.userDefault.synchronize()
                characterName.text = "\(nameTextfeild.text!) Lv.\(level)"
                currentHP = currentHP + 5 + level*2
                
                let characterHP = 16 + level*4
                if currentHP > characterHP
                {
                    currentHP = characterHP
                }
                self.userDefault.setValue(currentHP, forKey: "CurrentHP")
                self.userDefault.synchronize()
                characterHpLabel.text = "\(currentHP)/\(characterHP)"
            }
            else {
                levelreq = 2*(level - 1) + 1
                expWonLabel.text = "Gained some Exp \(exp)/\(levelreq)"
                currentHP = currentHP + (2 * level) + 1
                let characterHP = 16 + level*4
                if currentHP > characterHP
                {
                    currentHP = characterHP
                }
                characterHpLabel.text = "\(currentHP)/\(characterHP)"
            }
            
            
        }
        else{
        //enemy attacks, animates, and damages you
        if enemyName.text == "Slime"
        {
           
            if battle == true
            {
                
                image2.image = UIImage(named: "slimeA")
                image4.isHidden = true
                image2.isHidden = false
                battle = false
                let characterHP = 16 + level*4
                var yourDamage = [1,1,2,1,2,3,3,1,4]
                let number = Int(arc4random_uniform(9))
                currentHP = currentHP - (yourDamage[number] + 3 + 2*level)
                characterHpLabel.text = "\(currentHP)/\(characterHP)"
                okayToClick = true
            }
            
        }
        else if enemyName.text == "Bandit"
        {
            if battle == true
            {
                image2.image = UIImage(named: "manA")
                image4.isHidden = true
                image2.isHidden = false
                battle = false
                let characterHP = 16 + level*4
                var yourDamage = [5,3,4,6,4,2,5,6,4]
                let number = Int(arc4random_uniform(9))
                currentHP = currentHP - (yourDamage[number] + level*2)
                characterHpLabel.text = "\(currentHP)/\(characterHP)"
                okayToClick = true
            }
        }
        else
        {
            if battle == true
            {
                image2.image = UIImage(named: "treeA")
                image2.isHidden = false
                battle = false
                let characterHP = 16 + level*4
                var yourDamage = [1,2,3,3,1,2,2,4,2]
                let number = Int(arc4random_uniform(9))
                currentHP = currentHP - (yourDamage[number] + (level*3) - 4)
                characterHpLabel.text = "\(currentHP)/\(characterHP)"
                okayToClick = true
            }
        }
    }
        //animate character attack
        if characterAttack == false
        {
            
            image1.isHidden = false
            image3.isHidden = true
        
            
        }
        //apply damage and type
        if battlefiller == true {
            //triggers if attack bool is up, damage enemy
            if attack == true
            {
            var yourDamage = [4,4,4,4,4,5,5,5,6]
            let number = Int(arc4random_uniform(9))
            mobCurrent = mobCurrent - (yourDamage[number] + 2*(2 + level))
            enemyHpLabel.text = "\(mobCurrent)/\(mobHP)"
            attack = false
            }
                
            // triggers if double bool is up, deals extra damage at cost of hurting your own character
            else if double == true {
                var yourDamage = [3,3,3,3,5,5,6,6,7,]
                let number = Int(arc4random_uniform(9))
                mobCurrent = mobCurrent - (yourDamage[number] + level*3)
                enemyHpLabel.text = "\(mobCurrent)/\(mobHP)"
                
                let characterHP = 16 + level*4
                var backlashDamage = [1,2,2,3,3,4,4,3,2]
                let backlashnumber = Int(arc4random_uniform(9))
                currentHP = currentHP - (backlashDamage[backlashnumber] + (level))
                characterHpLabel.text = "\(currentHP)/\(characterHP)"
                double = false
            }
                
            //trigger if heal bool is up
            else if heal == true {
                let characterHP = 16 + level*4
                currentHP = currentHP + 5 + level*2
                if currentHP > characterHP
                {
                currentHP = characterHP
                }
                characterHpLabel.text = "\(currentHP)/\(characterHP)"
                heal = false
            }
            //check if enemy is dead before it get the chance to attack
            deadenemy = false
            if mobCurrent < 1
            {
                mobCurrent = 0
                enemyHpLabel.text = "\(mobCurrent)/\(mobHP)"
                print("you win")
                deadenemy = true
                image4.image = UIImage(named: "rip")
            }
            else
            {
                battlefiller = false
                battle = true
            }
            
        }
        
        // animate character attacj
        if characterAttack == true
        {
            image1.isHidden = true
            image3.isHidden = false
            if heal == true {
                image3.image = UIImage(named: "meditate")
            }else
            {
            image3.image = UIImage(named: "characterA")
            }
            characterAttack = false
            battlefiller = true
        }
    }
    
    
    
    
    //when a battle "scene" starts
    func battleStart(){

        let characterHP = 16 + level*4
        ///Generate enemy
        let randomMob = Int(arc4random_uniform(3))
        enemyName.text = "\(mobList[randomMob])"
        
        characterHpLabel.text = "\(currentHP)/\(characterHP)"
        
        //Create diverse enemy statlines
        if enemyName.text == "Bandit"
        {
            var hp = [2,4,5,6]
            let number = Int(arc4random_uniform(4))
            mobHP = hp[number] + level*(2 + level) + level
            mobCurrent = mobHP
            enemyHpLabel.text = "\(mobCurrent)/\(mobHP)"
            image4.image = UIImage(named: "man")
            
        }
        else if enemyName.text == "Slime" {
            var hp = [8,3,6,5]
            let number = Int(arc4random_uniform(4))
            mobHP = hp[number] + (3 + level)*2
            mobCurrent = mobHP
            enemyHpLabel.text = "\(mobCurrent)/\(mobHP)"
            image4.image = UIImage(named: "slime")
         
        }
        else
        {
            var hp = [4,5,6,8]
            let number = Int(arc4random_uniform(4))
            mobHP = hp[number] + level*6
            mobCurrent = mobHP
            enemyHpLabel.text = "\(mobCurrent)/\(mobHP)"
            image4.image = UIImage(named: "tree")
           
        }
     
    }
    
    @IBAction func attackAction(_ sender: AnyObject) {
        if okayToClick == true
        {
        attack = true
        characterAttack = true
        okayToClick = false
        }
        
    }
    
    @IBAction func doubleAttack(_ sender: AnyObject) {
        if okayToClick == true
        {
            double = true
            characterAttack = true
            okayToClick = false
        }
    }
    
    @IBAction func healAttack(_ sender: AnyObject) {
        if okayToClick == true
        {
            heal = true
            characterAttack = true
            okayToClick = false
            
        }
    }

    @IBAction func carryOnAction(_ sender: AnyObject) {
        carryonOutlet.isHidden = true
        endedBattleView.isHidden = true
        okayToClick = true
        characterAttack = false
        monsterAttack = false
        battle = false
        battlefiller = false
        //okayToClick = true
        attack = false
        double = false
        heal = false
        deadenemy = false
        timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(ViewController.animation), userInfo: nil, repeats: true)
        
        
    
    }
    
    @IBAction func enterName(_ sender: AnyObject) {
        if nameTextfeild.text == ""
        {
        }
        else
        {
            hidelabel.isHidden = true
            hidelabel1.isHidden = true
            hidelabel2.isHidden = true
            startingCover.isHidden = true
            nameTextfeild.isHidden = true
            nameTextfeild.resignFirstResponder()
            name = nameTextfeild.text!
            characterName.text = "\(name) Lv.\(level)"
            startButtonOutlet.isHidden = true
            self.userDefault.setValue(nameTextfeild.text, forKey: "Name")
            self.userDefault.synchronize()
        }
    }
    
   
    
    

}

