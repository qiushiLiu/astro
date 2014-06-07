//
//  ASShareBindVc.m
//  astro
//
//  Created by kjubo on 14-2-26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASShareBindVc.h"
#import "ASCustomer.h"
@interface ASShareBindVc ()
@end

static NSString *WeiboSSONotification = @"WeiboSSONotification";
@implementation ASShareBindVc
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    //web
    self.webView = [[UIWebView alloc] initWithFrame:self.contentView.bounds];
    self.webView.delegate = self;
    [self.contentView addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboNotification:) name:WeiboSSONotification object:nil];
    
    //显示等待
    [self showWaitingTitle:@"绑定中..."];
    //调整webView高度
    self.webView.height = self.contentView.height;
    //调整title
    self.title = [NSString stringWithFormat:@"第三方登录"];
    
    NSString *url = (self.type == emWeiboSina)? kUrlGetWeiboLoginUrl : kUrlGetQQLoginUrl;
    [self showWaiting];
    [HttpUtil load:url params:nil completion:^(BOOL succ, NSString *message, id json) {
        if(succ){
            BOOL ssoLoggingIn = NO;
            if(self.type == emWeiboSina){
                ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSinaiPadSSOUrl]];
                if(!ssoLoggingIn){
                    ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSinaiPhoneSSOUrl]];
                }
            }
            if(!ssoLoggingIn){
                [self openUrl:json];
            }
        }else{
            [self hideWaiting];
            [self alert:message];
        }
    }];
}

- (void)setNavToParams:(NSMutableDictionary *)params{
    self.type = [[params objectForKey:@"type"] intValue];
}

- (void)goBackWithSuccTag:(BOOL)succTag{
    [self.webView stopLoading];
    [self navBack];
}

- (void)dealloc{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView hideWithBtnIdx:(NSInteger)buttonIndex{
    if(self.tag == emBindTypeAccessToken){
        [self goBackWithSuccTag:NO];
    }
}

#pragma mark -
#pragma mark 网页控件
- (void) webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitingTitle:@"正在载入..."];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL isIntercept = [request.URL.host isEqualToString:@"www.ssqian.com"]
        && ([request.URL.absoluteString rangeOfString:kInterceptURL options:NSCaseInsensitiveSearch].location != NSNotFound);
    if (isIntercept) {
        //分析查询字符串  找到 code
        NSString *pstr = [request.URL query];
        if (pstr) {
            NSArray *a = [pstr componentsSeparatedByString:@"&"];
            for (int i=0; i<a.count; i++) {
                NSArray *b = [[a objectAtIndex:i] componentsSeparatedByString:@"="];
                if (b.count==2) {
                    NSString *key = [b objectAtIndex:0];
                    NSString *value = [b objectAtIndex:1];
                    if ([@"code" isEqualToString:key]) {
                        self.code = value;
                        break;
                    }
                }
            }
        }
        if (self.code) {
            [self bindWeibo];
        } else {
            [self goBackWithSuccTag:NO];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideWaiting];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideWaiting];
    if (error.code == 102 && [@"WebKitErrorDomain" isEqualToString:error.domain]) {
        return;
    } else if (error.code == -999 && [@"NSURLErrorDomain" isEqualToString:error.domain]) {
        return;
    }
    [self alert:@"网络异常，请稍后重试。"];
}

#pragma mark -
#pragma mark 其他
- (void)bindWeibo{
    [self showWaitingTitle:@"绑定中..."];
    self.tag = emBindTypeCode;
    NSString *url = (self.type == emWeiboSina)? kUrlWeiboLoginByCode : kUrlQQLoginByCode;
    NSDictionary *params = @{@"code": self.code};
    [self bindWeiboRequest:url params:params];
}

- (void)bindWeiboRequest:(NSString *)url params:(NSDictionary *)params{
    [HttpUtil load:url params:params completion:^(BOOL succ, NSString *message, id json) {
        if(succ){
            ASCustomer *user = [[ASCustomer alloc] initWithDictionary:json error:NULL];
            [ASGlobal login:user];
            [self hideWaiting];
            [self goBackWithSuccTag:YES];
        }else{
            [self hideWaiting];
            [self alert:message];
        }
    }];
}

//打开页面
- (void)openUrl:(NSString *)url{
    NSURLRequest *r = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithString:url]]];
    [self.webView loadRequest:r];
}

- (void)weiboNotification:(NSNotification *)sender{
    if([sender.name isEqualToString:WeiboSSONotification]){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        BOOL isSucc = [sender.object boolValue];
        if(isSucc){
            self.type = [[sender.userInfo objectForKey:@"type"] intValue];
            self.access_token = [sender.userInfo objectForKey:@"access_token"];
            self.uid = [sender.userInfo objectForKey:@"uid"];
            self.expires_in = [sender.userInfo objectForKey:@"expires_in"];
            [self showWaitingTitle:@"绑定中..."];
            self.tag = emBindTypeAccessToken;
        }else{
            [self goBackWithSuccTag:NO];
        }
    }
}

/**
 * @description sso回调方法，官方客户端完成sso授权后，回调唤起应用，应用中应调用此方法完成sso登录
 * @param url: 官方客户端回调给应用时传回的参数，包含认证信息等
 * @return YES
 */
+ (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:@"sinaweibosso"])
    {
        bool isSucc = NO;
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:Int2String(emWeiboSina) forKey:@"type"];
        if([urlString length] == 0)
        {
            isSucc = NO;
            [userInfo setObject:@"微博用户取消授权" forKey:@"msg"];
        } else if ([self getParamValueFromUrl:urlString paramName:@"sso_error_user_cancelled"])
        {
            isSucc = NO;
            [userInfo setObject:@"微博用户取消授权" forKey:@"msg"];
        }
        else if ([self getParamValueFromUrl:urlString paramName:@"sso_error_invalid_params"])
        {
            isSucc = NO;
            [userInfo setObject: @"微博授权参数不正确" forKey:@"msg"];
        }
        else if ([self getParamValueFromUrl:urlString paramName:@"error_code"])
        {
            isSucc = NO;
            //NSString *error_code = [self getParamValueFromUrl:urlString paramName:@"error_code"];
            //NSString *error = [self getParamValueFromUrl:urlString paramName:@"error"];
            //NSString *error_uri = [self getParamValueFromUrl:urlString paramName:@"error_uri"];
            NSString *msg = @"";
            if([self getParamValueFromUrl:urlString paramName:@"error_description"]){
                msg = [self getParamValueFromUrl:urlString paramName:@"error_description"];
            }
            [userInfo setObject:msg forKey:@"msg"];
        }
        else
        {
            NSString *access_token = [self getParamValueFromUrl:urlString paramName:@"access_token"];
            NSString *expires_in = [self getParamValueFromUrl:urlString paramName:@"expires_in"];
            NSString *uid = [self getParamValueFromUrl:urlString paramName:@"uid"];
            
            if(access_token != nil
               && expires_in != nil
               && uid != nil){
                isSucc = YES;
                [userInfo setObject:access_token forKey:@"access_token"];
                [userInfo setObject:expires_in forKey:@"expires_in"];
                [userInfo setObject:uid forKey:@"uid"];
            }else{
                isSucc = NO;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WeiboSSONotification object:[NSNumber numberWithBool:isSucc] userInfo:userInfo];
    }
    return YES;
}

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

@end
