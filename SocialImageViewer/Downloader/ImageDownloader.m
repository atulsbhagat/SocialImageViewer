//
//  ImageDownloader.m
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

-(id)initWithImageModel:(ImageModel *)imageRecord atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate
{
    if(self = [super init])
    {
        self.delegate = theDelegate;
        self.imageModel = imageRecord;
        self.indexPathInTableView = indexPath;
    }
    
    return self;
}

#pragma mark - Downloading image

-(void)main
{
    @autoreleasepool
    {
        if(self.isCancelled)
            return;
        
        NSURL *url = [NSURL URLWithString:self.imageModel.standardResolutionUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        if(self.isCancelled)
        {
            imageData = nil;
            return;
        }
        
        if(imageData)
        {
            UIImage *downloadedImage = [UIImage imageWithData:imageData];
            self.imageModel.standardImage = downloadedImage;
        }

        imageData = nil;
        
        if(self.isCancelled)
            return;
        
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
    }
}

@end
