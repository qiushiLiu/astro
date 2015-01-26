//
//  ASPostQuestion.m
//  astro
//
//  Created by kjubo on 14-7-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPostQuestion.h"

@implementation ASPostQuestion

- (id)init{
    if(self = [super init]){
        ASFateChart *ct = [[ASFateChart alloc] init];
        ct.FirstBirth = [NSDate initWithYear:1990 month:1 day:1 hour:12 minute:0 second:0];
        ct.FirstDayLight = 0;  //东八区
        ct.FirstGender = 1;    //男
        ct.FirstPoi = @"";
        ct.FirstTimeZone = -8;
        ct.FirstPoiName = @"";
        
        ct.SecondBirth = [NSDate initWithYear:1990 month:1 day:1 hour:12 minute:0 second:0];
        ct.SecondDayLight = 0;  //东八区
        ct.SecondGender = 1;    //男
        ct.SecondPoi = @"";
        ct.SecondTimeZone = - 8;
        ct.SecondPoiName = @"";
        
        self.Chart = ct;
    }
    return self;
}

- (void)setAstroModel:(AstroMod *)astro{
    if(!astro) return;
    self.Chart = [[ASFateChart alloc] init];
    self.Chart.FirstBirth = astro.birth;
    self.Chart.FirstDayLight = astro.IsDayLight;
    self.Chart.FirstGender = astro.Gender;
    self.Chart.FirstPoi = [NSString stringWithFormat:@"%f|%f", astro.position.longitude, astro.position.latitude];
    self.Chart.FirstPoiName = astro.position.name;
    self.Chart.FirstTimeZone = astro.zone;
    
    if(astro.type > 1){
        self.Chart.SecondBirth = astro.birth1;
        self.Chart.SecondDayLight = astro.IsDayLight1;
        self.Chart.SecondGender = astro.Gender1;
        self.Chart.SecondPoi = [NSString stringWithFormat:@"%f|%f", astro.position1.longitude, astro.position1.latitude];
        self.Chart.SecondPoiName = astro.position1.name;
        self.Chart.SecondTimeZone = astro.zone1;
    }
}

- (void)setBaziModel:(BaziMod *)bazi{
    if(!bazi) return;
    self.Chart = [[ASFateChart alloc] init];
    self.Chart.FirstBirth = bazi.BirthTime.Date;
    self.Chart.FirstDayLight = bazi.IsDayLight;
    self.Chart.FirstGender = bazi.Gender;
    self.Chart.FirstPoi = [NSString stringWithFormat:@"%@|%@", bazi.Longitude, @"35"];
    self.Chart.FirstPoiName = bazi.AreaName;
    self.Chart.FirstTimeZone = -8;
}

- (void)setZiWeiModel:(ZiWeiMod *)ziwei{
    if(!ziwei) return;
    self.Chart = [[ASFateChart alloc] init];
    self.Chart.FirstBirth = ziwei.BirthTime.Date;
    self.Chart.FirstDayLight = ziwei.IsDayLight;
    self.Chart.FirstGender = ziwei.Gender;
    self.Chart.FirstPoi = [NSString stringWithFormat:@"%@|%@", ziwei.Longitude, @"35"];
    self.Chart.FirstPoiName = ziwei.AreaName;
    self.Chart.FirstTimeZone = -8;
}
@end
