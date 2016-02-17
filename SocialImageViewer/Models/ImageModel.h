//
//  ImageModel.h
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property (nonatomic, copy) NSString *standardResolutionUrl;
@property (nonatomic, copy) NSString *lowResolutionUrl;
@property (nonatomic, copy) NSString *thumbnailUrl;

@property (nonatomic, strong) UIImage *standardImage;

@end
