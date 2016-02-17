//
//  ImageListTableViewController.m
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import "ImageListTableViewController.h"
#import "ImageModel.h"
#import "ImageTableViewCell.h"
#import "RoutingNavigationController.h"

#define URL_GET_TAGGED_MEDIA            @"https://api.instagram.com/v1/tags/selfie/media/recent?access_token="

static NSInteger const pageCount = 5;

@interface ImageListTableViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) NSInteger paginationCount;

@end

@implementation ImageListTableViewController

-(DownloadOperations *)downloadOperations
{
    if(!_downloadOperations)
    {
        _downloadOperations = [[DownloadOperations alloc] init];
    }
    
    return _downloadOperations;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageArray = [[NSMutableArray alloc] init];
    
    [self setTitle:@"Images"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCellIndentifier"];
    
    //Lets make it interesting
    //Adding clear buttom on left. This will clear all images!
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearImages)];
    
    //Adding "Load more" button on right to download more images, this is because of instagram api pagination
    //which returns 20 records per request
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Load more" style:UIBarButtonItemStylePlain target:self action:@selector(loadMoreTapped)];
    
    //We will limit reuqests for 5 max pages. Use clear button to view more images
    _paginationCount = 0;
    [self loadMoreTapped];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Image Loading

- (void)clearImages
{
    [self.imageArray removeAllObjects];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.paginationCount = 0;
    [self.tableView reloadData];
}

- (void)loadMoreTapped
{
    if (self.paginationCount < pageCount)
    {
        [self downloadImageMetadata];
        self.paginationCount = self.paginationCount + 1;

        if(self.paginationCount == pageCount)
        {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

- (void)downloadImageMetadata
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [queue addOperationWithBlock:^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_GET_TAGGED_MEDIA,self.accessToken]]];
        
        // Here you can handle response as well
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataElement = [dictResponse valueForKey:@"data"];
        NSLog(@"%@", dataElement);
        
        NSMutableArray *recordsArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dataElement)
        {
            NSDictionary *imageDict = [dict objectForKey:@"images"];
            
            NSDictionary *dictStandardResolution = [imageDict valueForKey:@"standard_resolution"];
            NSString *standardResolutionURL = [dictStandardResolution valueForKey:@"url"];
            
            NSDictionary *dictLowResolution = [imageDict valueForKey:@"low_resolution"];
            NSString *lowResolutionURL = [dictLowResolution valueForKey:@"url"];
            
            NSDictionary *dictThumbnail = [imageDict valueForKey:@"thumbnail"];
            NSString *thumbnailURL = [dictThumbnail valueForKey:@"url"];
            
            ImageModel *model = [[ImageModel alloc] init];
            model.standardResolutionUrl = standardResolutionURL;
            model.lowResolutionUrl = lowResolutionURL;
            model.thumbnailUrl = thumbnailURL;
            
            [recordsArray addObject:model];
        }
        
        [self.imageArray addObjectsFromArray:recordsArray];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
}

#pragma mark - Image Download

- (void)startImageDownload:(ImageModel *)imageModel forIndexPath:(NSIndexPath *)indexPath
{
    if(!imageModel || ([imageModel standardImage]))
        return;
    
    if(![self.downloadOperations.downloadsInProgress.allKeys containsObject:indexPath])
    {
        ImageDownloader *imgDownloader = [[ImageDownloader alloc] initWithImageModel:imageModel atIndexPath:indexPath delegate:self];
        
        [self.downloadOperations.downloadsInProgress setObject:imgDownloader forKey:indexPath];
        [self.downloadOperations.downloadQueue addOperation:imgDownloader];
    }
}

#pragma mark - Image Downloader Delegate

- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader
{
    NSIndexPath *indexPath = [downloader indexPathInTableView];
    
    [self.downloadOperations.downloadsInProgress removeObjectForKey:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; //Only 1 section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self imageArray] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //For Better Performance: LOAD IMAGES FOR VISIBLE CELLS ONLY
    
    static NSString *cellIdentifier = @"imageCellIndentifier";
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.imageView.image = nil;

    if(!cell.accessoryView)
    {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.hidesWhenStopped = YES;
        
        cell.accessoryView = activityIndicatorView;
    }

    ImageModel *imgModel = [self.imageArray objectAtIndex:indexPath.row];
    
    if([imgModel standardImage])
    {
        [(UIActivityIndicatorView *)cell.accessoryView stopAnimating];
        cell.imageView.image = imgModel.standardImage;
    }
    else
    {
        //Indicate image downloading
        [(UIActivityIndicatorView *)cell.accessoryView startAnimating];
        
        //Download image in background
        [self startImageDownload:imgModel forIndexPath:indexPath];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageModel *imgModel = [self.imageArray objectAtIndex:[indexPath row]];
    
    if([imgModel standardImage] != nil)
    {
        [[RoutingNavigationController sharedNavigationController] navigateToImageView:[imgModel standardImage]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
