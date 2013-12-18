//
//  ASBaseViewController.m
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"

@interface ASBaseViewController ()

@end

@implementation ASBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.queryParams = [[NSMutableDictionary alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest Method

- (void)httpGet:(NSString *)url tag:(NSInteger)tag{
    [self httpGet:url tag:tag params:nil];
}

- (void)httpGet:(NSString *)url tag:(NSInteger)tag params:(NSMutableDictionary *)params {
	[self httpGet:url tag:tag params:params timeOut:0] ;
}

- (void)httpGet:(NSString *)url tag:(int)tag params:(NSMutableDictionary *)params timeOut:(NSTimeInterval)sec {
    self.httpGetReq = [HttpUtil http:url
                              method:emHttpGet
                              params:params
                                data:nil
                             timeOut:sec
                   didFinishSelector:@selector(_requestFinished:)
                     didFailSelector:@selector(_requestFailed:)
                            delegate:self
                                tag:tag];
}


//提交请求成功
- (void)_requestFinished:(ASIHTTPRequest *)aRequest {
    if (kAppDebug) {
        NSLog(@">%@",[aRequest responseString]);
    }
    
    NSDictionary *re = [[aRequest responseString] objectFromJSONString];
    NSInteger code = [[re objectForKey:@"code"] intValue];
    if (code == 200) {
        [self onHttpRequestSuccess:[re objectForKey:@"value"] tag:aRequest.tag];
    } else {
        [self onHttpRequestFail:code errorMsg:[re objectForKey:@"msg"] tag:aRequest.tag];
    }
}

//提交请求失败
- (void)_requestFailed:(ASIHTTPRequest *)aRequest {
//    int code = [[aRequest error] code];
//    if (code == 1) {
//        [self processWhenRequestError:@"似乎已断开与互联网的连接" tag:aRequest.tag];
//    } else if (code == 2) {
//        if (self.hintSysErrorOnRequestFailedTag) {
//            [self processWhenRequestError:@"抱歉,网络查询超时" tag:aRequest.tag];
//        }
//    } else {
//        [self onHttpRequestFail:-1 errorMsg:@"网络查询出错" tag:aRequest.tag];
//    }
}

- (void)onHttpRequestSuccess:(NSMutableDictionary *)obj tag:(int)tag{
}

- (void)onHttpRequestFail:(int)errorTag errorMsg:(NSString *)msg tag:(int)tag{
}


@end
