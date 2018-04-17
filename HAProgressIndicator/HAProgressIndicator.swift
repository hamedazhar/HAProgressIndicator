//
//  CustomProgressView.swift
//  HAProgresssIndicator
//
//  Created by Hamed Azhar on 17/04/18.
//  Copyright © 2018 Hamed Azhar. All rights reserved.
//

import UIKit

public class HAProgressIndicator: UIView
{
    /* The maximum width for the text label inside the loading view. */
    private static let maxLabelWidth = (kScreenWidth/2)-20
    
    /* The height of the on-screen keyborad(if presented) */
    private static var keyboardHeightValue = CGFloat()
    
    /* The view to which the loading view has to be presented */
    private static var container: UIView = UIView()
    
    /* The loading view. */
    private static var loadingView: UIVisualEffectView = UIVisualEffectView()
    
    /* The activity indicator used. */
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    /* The duration for which the animation */
    private static var animatingDuration = Bool()
    
    /* The window. */
    private static let window = kWindow
    
    /* A bool value which enables(or disables) the user interaction during the loading animation. */
    private static var userInteractionBoolValue = Bool()
    
    /* A bool value which enables(or disables) the text label inside the loading view. */
    private static var messageBoolValue = Bool()
    
    /* The message text.*/
    private static var messageString = String()
    
    /* The message label. */
    private static var messageLabel = UILabel()

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* Method to set the frame of the loading view.*/
    private static func setFrame()
    {
        keyboardHeightValue = keyboardHeight()
        loadingView.transform = CGAffineTransform(scaleX: 1, y: 1)

        if messageBoolValue
        {
            //get frame of message label
            
            let attributesDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 17)]
            let messageStringFrame = NSString(format: "%@", messageString).boundingRect(with: CGSize(width:maxLabelWidth,height:300), options: .usesLineFragmentOrigin, attributes: attributesDictionary, context: nil)
            
            messageLabel.lineBreakMode = .byWordWrapping
            messageLabel.numberOfLines = 0
            messageLabel.text = messageString
            
            let messageLabelFrame = CGRect(x: 20, y: 70, width: max(80,messageStringFrame.size.width), height:round(messageStringFrame.size.height))
            messageLabel.frame = messageLabelFrame
            
            // set frame for loadingView
            loadingView.frame = CGRect(x: 0, y: 0, width: max(80,messageStringFrame.size.width+40), height: 90+round(messageStringFrame.size.height))
            loadingView.effect = UIBlurEffect.init(style: .light)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            // set frame for activityIndicator
            
            activityIndicator.frame =  CGRect(x: (loadingView.frame.size.width/2)-20, y: 20, width: 40, height: 40)
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.color = UIColor.red
        }
        else
        {
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.effect = UIBlurEffect.init(style: .light)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            activityIndicator.frame =  CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.color = UIColor.red
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        }
        
        if keyboardHeightValue == 0
        {
            loadingView.center = window.center
        }
        else
        {
            loadingView.center.x = UIScreen.main.bounds.size.width/2
            loadingView.center.y = UIScreen.main.bounds.size.height/2 - keyboardHeightValue/2
        }
    }
     /* Method to set the user-interaction enabled(or diabled). */
    private static func setUserInteractionDisabled()
    {
        if !userInteractionBoolValue {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }

     /* Method to present the loading view. */
    public static func showIndicator(userInteractionEnabled:Bool) {
        
        messageBoolValue = false
        userInteractionBoolValue = userInteractionEnabled
        
        setFrame()
        loadingView.addSubview(activityIndicator)
        setUserInteractionDisabled()
        window.addSubview(loadingView)
        activityIndicator.startAnimating()
        startShowingProgressView()
    }
    
    /* Method to present the loading view with text. */
    public static func showIndicator(message:String!, userInteractionEnabled:Bool) {
        
        messageBoolValue = true
        messageString = message
        userInteractionBoolValue = userInteractionEnabled
        
        setFrame()
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(messageLabel)
        setUserInteractionDisabled()
        window.addSubview(loadingView)
        activityIndicator.startAnimating()
        startShowingProgressView()
    }
    
    /* Method to dismiss the loading view. */
    public static func dismiss() {
        activityIndicator.stopAnimating()
        dismissingProgressView()
    }
    
    private static func UIColorFromHex(rgbValue:UInt32, alpha:Double)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    /* Method to start showing the loading view. */
    private static func startShowingProgressView()
    {
        loadingView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        animatingDuration = true
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [UIViewAnimationOptions.curveEaseIn,UIViewAnimationOptions.allowUserInteraction], animations: {
            loadingView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: { (finished: Bool) in
            animatingDuration = false
        })
    }
    
    /* Method to stop showing the loading view .*/
    private static func dismissingProgressView()
    {
        animatingDuration = true
        UIView.animate(withDuration: 0.2, delay: 0, options: [UIViewAnimationOptions.curveEaseIn,UIViewAnimationOptions.allowUserInteraction], animations: {
            loadingView.transform = CGAffineTransform(scaleX:0.2, y:0.2)
            
        }, completion: { (finished: Bool) in
            animatingDuration = false
            loadingView.removeFromSuperview()
            if !userInteractionBoolValue {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        })
    }
    
    /* Method to calculate keyboard height. */
    private static func keyboardHeight() -> CGFloat
    {
        for testWindow in  UIApplication.shared.windows{
            if String(describing: testWindow) != String(describing: UIWindow())
            {
                for possibleKeyboard in testWindow.subviews
                {
                    if possibleKeyboard.description.hasPrefix("<UIPeripheralHostView")
                    {
                        return possibleKeyboard.bounds.size.height
                    }
                    else if possibleKeyboard.description.hasPrefix("<UIInputSetContainerView")
                    {
                        for hostKeyboard in possibleKeyboard.subviews
                        {
                            if hostKeyboard.description.hasPrefix("<UIInputSetHost")
                            {
                                return hostKeyboard.frame.size.height
                            }
                        }
                    }
                }
            }
        }
        return 0
    }
}
