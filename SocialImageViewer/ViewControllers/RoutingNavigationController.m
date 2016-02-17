//
//  RoutingNavigationController.m
//  SocialImageViewer
//
//  Created by Atul Bhagat on 16/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import "RoutingNavigationController.h"
#import "LoginViewController.h"
#import "ImageListTableViewController.h"
#import "ImageViewController.h"

static RoutingNavigationController *sharedRoutingNavigationController = nil;

@implementation RoutingNavigationController

+(id)sharedNavigationController
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedRoutingNavigationController = [[self alloc] init];
    });
    
    return sharedRoutingNavigationController;
}

- (void)setRootViewController:(UIViewController *)viewController
{
    [self setViewControllers:@[viewController] animated:YES];
}

- (void)navigateToLoginAuthenticationView
{
    id viewController = [[LoginViewController alloc] init];
    [[RoutingNavigationController sharedNavigationController] setRootViewController:viewController];
}

- (void)navigateToImageListView:(NSString *)accessToken
{
    id imageListVC = [[ImageListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [imageListVC setAccessToken:accessToken];
    [[RoutingNavigationController sharedNavigationController] setRootViewController:imageListVC];
}

- (void)navigateToImageView:(UIImage *)image
{
    id imageVC = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    [imageVC setImage:image];
    [[RoutingNavigationController sharedNavigationController] pushViewController:imageVC animated:YES];
}

@end
