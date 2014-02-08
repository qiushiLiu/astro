//
//  ASToolBar.h
//  astro
//
//  Created by kjubo on 14-2-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    emModuleApp = 1,
    emModuleAsk,
    emModulePan,
    emModuleUser,
    emModuleSet,
}emModule;

@protocol ASToolBarDelegate <NSObject>

@optional
- (void)toolBarDidChange:(emModule)tag;
@end

@interface ASToolBar : UIView
@property (nonatomic) emModule selected;
@property (nonatomic, assign) id<ASToolBarDelegate> delegate;
@end
