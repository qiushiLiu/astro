//
//  ASObjectDelegate.h
//  astro
//
//  Created by kjubo on 13-12-26.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASObject;

@protocol ASObjectDelegate <NSObject>
@optional
- (void)modelBeginLoad:(ASObject *)sender;
- (void)modelLoadFinished:(ASObject *)sender;
- (void)modelLoadFaild:(ASObject *)sender message:(NSString *)msg;
@end
