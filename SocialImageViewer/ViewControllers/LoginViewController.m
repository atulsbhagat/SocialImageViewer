//
//  LoginViewController.m
//  SocialImageViewer
//
//  Created by Atul Bhagat on 15/02/16.
//  Copyright © 2016 Atul Bhagat. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "RoutingNavigationController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Authentication"];
    
    [self configureWebView];
    
    //Using Client-Side (Implicit) Authentication
    [self initiateAuthorization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.relativeString;

    if ([self containAuthenticationToken:url])
    {
        NSString *accessToken = [self extractAuthorizationToken:url];
        [self saveAuthenticationToken:accessToken];

        [[RoutingNavigationController sharedNavigationController] navigateToImageListView:accessToken];
        return NO;
    }
    else if([self accessDenied:url]) //Not tested
    {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Access Denied"
                                                                             message:@"User denied the access to Instagram account!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
    
    NSLog(@"%@", url);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Helper Methods

- (void)configureWebView
{
    _mAuthenticationWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.mAuthenticationWebView.delegate = self;
    [self.view addSubview:_mAuthenticationWebView];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mAuthenticationWebView);
    
    [_mAuthenticationWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mAuthenticationWebView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mAuthenticationWebView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}

- (NSString *)authorizationUrl
{
    NSString *clientIDString = [NSString stringWithFormat:@"client_id=%@", CLIENT_ID];
    NSString *redirectString = [NSString stringWithFormat:@"redirect_uri=%@", URL_REDIRECTION];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@&%@&%@", URL_AUTHORIZATION, clientIDString, redirectString, RESPONSE_TYPE];
    
    return urlString;
}

- (void)saveAuthenticationToken:(NSString *)authenticationToken
{
    [[NSUserDefaults standardUserDefaults] setValue:authenticationToken forKey:ACCESS_TOKEN];
}

- (void)initiateAuthorization
{
    NSString *urlString = [self authorizationUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *authURLRequest = [NSMutableURLRequest requestWithURL:url];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.mAuthenticationWebView loadRequest:authURLRequest];
}

- (NSString *)accessTokenRedirectionString
{
    NSString *tokenResponseString = [NSString stringWithFormat:@"%@/#access_token=", URL_REDIRECTION];
    return tokenResponseString;
}

- (BOOL)containAuthenticationToken:(NSString *)url
{
    NSString *tokenResponseString = [self accessTokenRedirectionString];
    return [url containsString:tokenResponseString];
}

- (NSString *)extractAuthorizationToken:(NSString *)responseUrlString
{
    NSUInteger tokenStartIndex = [[self accessTokenRedirectionString] length];
    NSString *authorizationTokenString = [responseUrlString substringFromIndex:tokenStartIndex];

    return authorizationTokenString;
}

- (BOOL)accessDenied:(NSString *)urlString
{
    NSString *accessDeniedResponseString = [NSString stringWithFormat:@"%@?error=access_denied", URL_REDIRECTION];
    return [urlString containsString:accessDeniedResponseString];
}

@end
