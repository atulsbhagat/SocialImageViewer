//
//  DownloadOperations.m
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import "DownloadOperations.h"

@implementation DownloadOperations

-(NSMutableDictionary *)downloadsInProgress
{
    if(!_downloadsInProgress)
    {
        _downloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    
    return _downloadsInProgress;
}

-(NSOperationQueue *)downloadQueue
{
    if(!_downloadQueue)
    {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = QUEUE_NAME_DOWNLOAD;
    }
    
    return _downloadQueue;
}

@end
