//
//  LoginViewController.h
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *mAuthenticationWebView;

@end

