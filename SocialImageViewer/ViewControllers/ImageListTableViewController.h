//
//  ImageListTableViewController.h
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "DownloadOperations.h"

@interface ImageListTableViewController : UITableViewController <ImageDownloaderDelegate>

@property (nonatomic, strong) DownloadOperations *downloadOperations;
@property (nonatomic, copy) NSString *accessToken;

@end
