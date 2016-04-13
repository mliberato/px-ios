//
//  CheckoutViewController.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 13/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

public class CheckoutViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var preference : CheckoutPreference?
    var publicKey : String!
    var accessToken : String!
    var bundle : NSBundle? = MercadoPago.getBundle()
    var callback : (Payment -> Void)!
    var paymentMethod : PaymentMethod?
    var installments : Int = 0
    var issuer : Issuer?
    var cardToken : CardToken?
    var paymentButton : MPButton?

    
    var payerCost : PayerCost?
    
    private var reviewAndConfirmContent = Set<String>()
    
    @IBOutlet weak var checkoutTable: UITableView!
    
    init(preference : CheckoutPreference, callback : (Payment -> Void)){
        super.init(nibName: "CheckoutViewController", bundle: MercadoPago.getBundle())
        self.preference = preference
        self.publicKey = MercadoPagoContext.publicKey()
        self.accessToken = MercadoPagoContext.merchantAccessToken()
        self.callback = callback
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {

        super.viewDidLoad()

        //Display preference description by default
        self.displayPreferenceDescription = true
        
        self.title = "¿Cómo quieres pagar?".localized

        //Register rows
        let offlinePaymentMethodNib = UINib(nibName: "OfflinePaymentMethodCell", bundle: self.bundle)
        self.checkoutTable.registerNib(offlinePaymentMethodNib, forCellReuseIdentifier: "offlinePaymentCell")
        let preferenceDescriptionCell = UINib(nibName: "PreferenceDescriptionTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(preferenceDescriptionCell, forCellReuseIdentifier: "preferenceDescriptionCell")
        let selectPaymentMethodCell = UINib(nibName: "SelectPaymentMethodCell", bundle: self.bundle)
        self.checkoutTable.registerNib(selectPaymentMethodCell, forCellReuseIdentifier: "selectPaymentMethodCell")
        let paymentDescriptionFooter = UINib(nibName: "PaymentDescriptionFooterTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(paymentDescriptionFooter, forCellReuseIdentifier: "paymentDescriptionFooter")
        let purchaseTermsAndConditions = UINib(nibName: "TermsAndConditionsViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(purchaseTermsAndConditions, forCellReuseIdentifier: "purchaseTermsAndConditions")
        let copyrightCell = UINib(nibName: "CopyrightTableViewCell", bundle: self.bundle)
        self.checkoutTable.registerNib(copyrightCell, forCellReuseIdentifier: "copyrightCell")
        
        self.checkoutTable.delegate = self
        self.checkoutTable.dataSource = self
        self.checkoutTable.separatorStyle = .None
        
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Remove navigation items
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil

    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && displayPreferenceDescription {
            return 0.1
        }
        return 8
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.displayPreferenceDescription {
                return 120
            }
            return 0
        }
        
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 1 {
            return 60
        }
        return 180
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.displayPreferenceDescription ? 1 : 0
        }
        return (self.paymentMethod == nil) ? 2 : 3
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let preferenceDescriptionCell = tableView.dequeueReusableCellWithIdentifier("preferenceDescriptionCell", forIndexPath: indexPath) as! PreferenceDescriptionTableViewCell
            preferenceDescriptionCell.fillRowWithPreference(self.preference!)
            return preferenceDescriptionCell
        }
    
        if indexPath.row == 0 {
            if self.paymentMethod != nil {
                if self.paymentMethod!.isOfflinePaymentMethod() {
                    self.title = "Revisa si está todo bien...".localized
                } else {
                    self.title = "Tantito más y terminas…".localized
                }

                //TODO : solo funciona con offlinePayment
                let cell = tableView.dequeueReusableCellWithIdentifier("offlinePaymentCell", forIndexPath: indexPath) as! OfflinePaymentMethodCell
                cell.fillRowWithPaymentMethod(self.paymentMethod!)
                return cell
            }
            
            return tableView.dequeueReusableCellWithIdentifier("selectPaymentMethodCell", forIndexPath: indexPath) as! SelectPaymentMethodCell
        } else if indexPath.row == 1 {
            let footer = self.checkoutTable.dequeueReusableCellWithIdentifier("paymentDescriptionFooter") as! PaymentDescriptionFooterTableViewCell
            
            footer.layer.shadowOffset = CGSizeMake(0, 1)
            footer.layer.shadowColor = UIColor(red: 153, green: 153, blue: 153).CGColor
            footer.layer.shadowRadius = 1
            footer.layer.shadowOpacity = 0.6
            footer.setAmount(self.preference!.getAmount())
            return footer
        }
        
        let termsAndConditionsButton = self.checkoutTable.dequeueReusableCellWithIdentifier("purchaseTermsAndConditions") as! TermsAndConditionsViewCell
        termsAndConditionsButton.paymentButton.addTarget(self, action: "confirmPayment", forControlEvents: .TouchUpInside)
        self.paymentButton = termsAndConditionsButton.paymentButton
        return termsAndConditionsButton
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.checkoutTable.deselectRowAtIndexPath(indexPath, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.checkoutTable.deselectRowAtIndexPath(indexPath, animated: true)
            self.startPaymentVault()
        }
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1) ? 140 : 0
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return self.checkoutTable.dequeueReusableCellWithIdentifier("copyrightCell")
        }
        return nil
    }
    
    internal func startPaymentVault(){
        MPFlowController.popToRoot(true)
    }
    
    internal func confirmPayment(){

        
        self.paymentButton!.alpha = 0.4
        self.paymentButton!.enabled = false

        if ((self.paymentMethod?.isOfflinePaymentMethod()) != nil){
            self.confirmPaymentOff()
        }else{
                 MPServicesBuilder.createNewCardToken(self.cardToken!, success: { (token) -> Void in
                    let payment = Payment()
                    payment.transactionAmount = self.preference!.getAmount()
                    payment.tokenId = token?._id
                    payment.issuerId = self.issuer != nil ? self.issuer!._id!.integerValue : 0
                    payment.paymentMethodId = self.paymentMethod!._id
                    //TODO
                    payment._description = self.preference!.items![0].title
                    self.confirmPaymentOn(payment, token: token!)
                 }) { (error) -> Void in
                     print("Falla!")
             }
        }
        
        
       
    }
    
    internal func confirmPaymentOff(){
        MercadoPago.createMPPayment(self.preference!.payer.email, preferenceId: self.preference!._id, paymentMethod: self.paymentMethod!,token : nil, payerCost: nil, issuer: nil,success: { (payment) -> Void in
            payment._id = 1826446924
            MPFlowController.push(MPStepBuilder.startInstructionsStep(payment, callback: {(payment : Payment) -> Void  in
                    self.clearMercadoPagoStyle()
                    self.callback(payment)
                }))
           }, failure : { (error) -> Void in
                //TODO : remove / payment failed
            let payment = Payment()
            payment.transactionAmount = self.preference!.getAmount()
            payment.issuerId = self.issuer != nil ? self.issuer!._id!.integerValue : 0
            payment.paymentMethodId = self.paymentMethod!._id
            payment._description = self.preference!.items![0].title
            payment._id = 1826446924
                MPFlowController.push(MPStepBuilder.startInstructionsStep(payment, callback: {(payment : Payment) -> Void  in
                    self.clearMercadoPagoStyle()
                    self.callback(payment)
                }))
                
        })
    }
    
    internal func confirmPaymentOn(payment : Payment , token : Token){
        MercadoPago.createMPPayment(self.preference!.payer.email, preferenceId: self.preference!._id, paymentMethod: self.paymentMethod!,token : token, payerCost:payerCost , issuer: self.issuer,success: { (payment) -> Void in
            
                self.clearMercadoPagoStyleAndGoBack()
                MPFlowController.dismiss(true)
            }, failure : { (error) -> Void in
                //TODO : remove / payment failed
                MPFlowController.push(MPStepBuilder.startInstructionsStep(payment, callback: {(payment : Payment) -> Void  in
                    self.clearMercadoPagoStyle()
                    self.callback(payment)
                }))
                
        })
    }
    
    internal func togglePreferenceDescription(){
        self.togglePreferenceDescription(self.checkoutTable)
    }
    
}
