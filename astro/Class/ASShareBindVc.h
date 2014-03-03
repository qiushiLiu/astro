//
//  ASShareBindVc.h
//  astro
//
//  Created by kjubo on 14-2-26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"

typedef enum {
    emBindTypeCode = 1,
    emBindTypeAccessToken,
}emBindType;

typedef enum {
    emWeiboSina = 1,
    emWeiboTencent = 2,
}emWeiboType;

@interface ASShareBindVc : ASBaseViewController<UIWebViewDelegate>
//网页控件
@property (nonatomic, retain) UIWebView *webView;
//绑定类型
@property (nonatomic) emBindType type;
//http请求类型
@property (nonatomic) emBindType tag;
//授权Code
@property (nonatomic, retain) NSString *code;

//客户端授权 返回
@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *expires_in;

+ (BOOL)handleOpenURL:(NSURL *)url;
@end
