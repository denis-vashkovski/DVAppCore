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

#import <WebKit/WebKit.h>

@interface ACWebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ACWebViewController

+ (instancetype)openUrl:(NSURL *)url withPresentingVC:(UIViewController *)presentingVC {
    if (!url || !presentingVC) return nil;
    
    ACWebViewController *webViewController = [ACWebViewController new];
    [webViewController setUrl:url];
    [webViewController ac_embedInNavigationController];
    
    [presentingVC presentViewController:webViewController.navigationController
                               animated:YES
                             completion:nil];
    
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
    
    NSString *jScript = @" \
    var meta = document.createElement('meta'); \
    meta.setAttribute('name', 'viewport'); \
    meta.setAttribute('content', 'width=device-width'); \
    document.getElementsByTagName('head')[0].appendChild(meta); \
    ";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript
                                                     injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                  forMainFrameOnly:YES];
    WKUserContentController *wkUController = [WKUserContentController new];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [WKWebViewConfiguration new];
    wkWebConfig.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView ac_addConstraintsEqualSuperview];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
    [self ac_startLoadingProcess];
    NSLog(@"ACWebViewController start load %@", self.webView.URL.absoluteString);
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self ac_stopLoadingProcess];
    NSLog(@"ACWebViewController end load %@", webView.URL.absoluteString);
    
    self.title = webView.title;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
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
