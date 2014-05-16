//
//  ZiWeiStar.h
//  astro
//
//  Created by kjubo on 14-3-13.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

@protocol ZiWeiStar
@end

@interface ZiWeiStar : JSONModel
@property (nonatomic) NSInteger StarName;
@property (nonatomic) NSInteger Gong;
@property (nonatomic) NSInteger Hua;
@property (nonatomic) NSInteger YunHua;
@property (nonatomic) NSInteger LiuHua;
@property (nonatomic) NSInteger Wang;
@end
