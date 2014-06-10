//
//  AstroStarGroup.h
//  astro
//
//  Created by kjubo on 14-6-10.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AstroStar.h"
@interface AstroStarGroup : NSObject
@property (nonatomic) CGFloat degreeStart;
@property (nonatomic) CGFloat degreeEnd;
@property (nonatomic, strong) NSMutableArray *stars;

//- (BOOL)relationTo:(AstroStar *)star;
- (BOOL)nearTo:(AstroStarGroup *)gp;
- (void)addNewStar:(AstroStarHD *)star;
- (void)joinStars:(NSArray *)stars;
@end
