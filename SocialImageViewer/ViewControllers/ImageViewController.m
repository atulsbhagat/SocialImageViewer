//
//  ImageViewController.m
//  SocialImageViewer
//
//  Created by Atul Bhagat on 16/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureWebView];
    
    [self setTitle:@"Full Image"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWebView
{
    UIImageView *enlargeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [enlargeImageView setContentMode:UIViewContentModeScaleAspectFit];
    enlargeImageView.image = _image;
    
    [self.view addSubview:enlargeImageView];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(enlargeImageView);
    
    [enlargeImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[enlargeImageView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[enlargeImageView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}

@end
