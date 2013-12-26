//
//  ASObject.h
//  astro
//
//  Created by kjubo on 13-12-21.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JSON.h"
#import "ASIHTTPRequest.h"
#import "HttpUtil.h"
#import "ASObjectDelegate.h"

@interface ASObject : NSObject<ASIHTTPRequestDelegate>{
    ASIHTTPRequest *_request;
}
@property (nonatomic, assign) id<ASObjectDelegate> delegate;
@end
