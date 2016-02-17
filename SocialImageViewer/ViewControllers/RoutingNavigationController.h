//
//  RoutingNavigationController.h
//  SocialImageViewer
//
//  Created by Atul Bhagat on 16/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutingNavigationController : UINavigationController

+(id)sharedNavigationController;

- (void)navigateToLoginAuthenticationView;
- (void)navigateToImageListView:(NSString *)accessToken;
- (void)navigateToImageView:(UIImage *)image;

@end
