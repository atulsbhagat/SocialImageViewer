//
//  ImageDownloader.h
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModel.h"

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSOperation

@property (nonatomic, weak) id<ImageDownloaderDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, strong) ImageModel *imageModel;

-(id)initWithImageModel:(ImageModel *)imageRecord atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate;

@end

@protocol ImageDownloaderDelegate <NSObject>

-(void)imageDownloaderDidFinish:(ImageDownloader *)downloader;

@end
