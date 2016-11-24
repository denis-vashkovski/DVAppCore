//
//  ACWebViewController.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACWebViewController.h"

#import "ACLog.h"

#import "UIView+AppCore.h"

@interface ACWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ACWebViewController

+ (instancetype)openUrl:(NSURL *)url withPresentingVC:(UIViewController *)presentingVC {
    if (!url || !presentingVC) return nil;
    
    ACWebViewController *webViewController = [ACWebViewController new];
    [webViewController setUrl:url];
    [webViewController ac_embedInNavigationController];
    
    [presentingVC presentViewController:webViewController.navigationController animated:YES completion:nil];
    
    return webViewController;
}

+ (instancetype)openUrl:(NSURL *)url withPushingNVC:(UINavigationController *)pushingNVC {
    if (!url || !pushingNVC) return nil;
    
    ACWebViewController *webViewController = [ACWebViewController new];
    [webViewController setUrl:url];
    
    [pushingNVC pushViewController:webViewController animated:YES];
    
    return webViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.presentingViewController) {
        [self.navigationItem setLeftBarButtonItem:[self ac_backButton]];
    }
    
    self.webView = [UIWebView new];
    [self.view addSubview:self.webView];
    [self.webView ac_addConstraintsEqualSuperview];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self ac_startLoadingProcess];
    NSLog(@"ACWebViewController start load %@", webView.request.URL.absoluteString);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self ac_stopLoadingProcess];
    NSLog(@"ACWebViewController end load %@", webView.request.URL.absoluteString);
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self ac_stopLoadingProcess];
    NSLog(@"ACWebViewController catch error: %@", error);
}

#pragma mark - Actions
- (void)ac_onBackButtonTouch:(UIBarButtonItem *)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super ac_onBackButtonTouch:sender];
    }
}

@end
