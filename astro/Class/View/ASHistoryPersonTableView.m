//
//  ASHistoryPersonTableView.m
//  astro
//
//  Created by kjubo on 15/4/29.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASHistoryPersonTableView.h"
#import "ASCache.h"

@interface ASHistoryPersonTableView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *kCacheDir = @"kHistoryPersonDir";
static NSString *kCacheKey = @"kHistoryPersonKey";

@implementation ASHistoryPersonTableView

+ (ASHistoryPersonTableView *)shared{
    static ASHistoryPersonTableView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASHistoryPersonTableView alloc] initWithFrame:CGRectMake(0, 0, DF_WIDTH, 1) style:UITableViewStyleGrouped];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.dataArray = [NSMutableArray array];
        ASCacheObject *cf = [[ASCache shared] readDicFiledsWithDir:kCacheDir key:kCacheKey];
        if (cf) {
            //设置登录信息
            NSData *data = [cf.value dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr = [ASPerson arrayOfModelsFromData:data error:nil];
            if([arr count] > 0){
                [self.dataArray addObjectsFromArray:arr];
            }
        }
        
    }
    return self;
}

- (void)saveToCache{
    if(self.dataArray){
        [[ASCache shared] storeValue:[self.dataArray toJSONString] dir:kCacheDir key:kCacheKey];
    }
}

- (void)addPerson:(ASPerson *)person{
    [self.dataArray addObject:[person copy]];
    [self reloadData];
    [self saveToCache];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.row < [self.dataArray count]){
        ASPerson *item = self.dataArray[indexPath.row];
        NSMutableString *str = [NSMutableString stringWithString:[item.Birth toStrFormat:@"yyyy-MM-dd HH:mm"]];
        if(item.DayLight > 0){
            [str appendString:@" 夏令时"];
        }
        if(item.Gender == 1){
            [str appendString:@" 男"];
        }else{
            [str appendString:@" 女"];
        }
        
        cell.textLabel.text = str;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
