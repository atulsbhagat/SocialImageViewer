//
//  DownloadOperations.h
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QUEUE_NAME_DOWNLOAD         @"Download_Queue"

@interface DownloadOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end
