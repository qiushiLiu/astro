//
//  ASBaseViewController.h
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HttpUtil.h"

@interface ASBaseViewController : UIViewController
//post请求
@property (nonatomic, strong) ASIFormDataRequest *httpPostReq;
//get请求
@property (nonatomic, strong) ASIHTTPRequest *httpGetReq;
//查询参数
@property (nonatomic, strong) NSMutableDictionary *queryParams;
//隐藏时是否关闭请求
@property BOOL closeHttpReqWhenHideTag;
//请求失败时候 需要提示系统错误
@property BOOL hintSysErrorOnRequestFailedTag;
//系统提示 可以点击重试
@property BOOL hintSysErrorCanTryAgainTag;
@end
