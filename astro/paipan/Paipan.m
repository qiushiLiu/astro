//
//  Paipan.m
//  astro
//
//  Created by kjubo on 14-3-21.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "Paipan.h"

NSString* GetTianGan(NSInteger tag) { return [__TianGan objectAtIndex:tag];}
NSString* GetDiZhi(NSInteger tag){ return [__DiZhi objectAtIndex:tag];}
NSString* GetNongliMonth(NSInteger tag){ return [__NongliMonth objectForKey:[NSNumber numberWithInteger:tag]]; }
NSString* GetNongliDay(NSInteger tag){ return [__NongliDay objectAtIndex:tag]; }
NSString* GetShiShen(NSInteger tag){ return [__ShiShen objectAtIndex:tag]; }
NSString* GetShiChenByTg(NSInteger tg1, NSInteger tg2){
    int shichen = __WuXing[tg1][tg2];
    return [__ShiShen objectAtIndex:shichen];
}

NSString* GetZiWeiStar(NSInteger tag){ return [__ZiWeiStar objectAtIndex:tag]; }
NSString* GetZiWeiGong(NSInteger tag){ return [__ZiWeiGong objectAtIndex:tag]; }
NSString* GetZiWeiLiuYao(NSInteger tag){ return [__ZiWeiLiuYao objectAtIndex:tag]; }
