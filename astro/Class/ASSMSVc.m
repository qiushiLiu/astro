//
//  ASSMSVc.m
//  astro
//
//  Created by kjubo on 14/12/4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASSMSVc.h"
#import "ASUSR_SMS.h"
@interface ASSMSVc ()
@property (nonatomic, strong) ASBaseSingleTableView *tbList;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ASSMSVc

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"我的消息";
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
    self.tbList.hasMore = NO;
    self.list = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbList.height = self.contentView.height;
}

- (void)loadMore{
    [HttpUtil load:@"customer/GetSMSTalk"
            params:@{@"sysno" : @(self.sysNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self.list addObjectsFromArray:[ASUSR_SMS arrayOfModelsFromDictionaries:json]];
            [self.tbList reloadData];
    }];

}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASUSR_SMS *item = [self.list objectAtIndex:indexPath.row];
    return 40 + [item.Context sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ASUrlImageView *ivFace = [[ASUrlImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        ivFace.tag = 99;
        [cell.contentView addSubview:ivFace];
        
        UILabel *lbContext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 1)];
        lbContext.tag = 101;
        lbContext.lineBreakMode = NSLineBreakByCharWrapping;
        lbContext.backgroundColor = [UIColor clearColor];
        lbContext.textColor = [UIColor blackColor];
        lbContext.font = [UIFont systemFontOfSize:12];
        
        UIImageView *ivContentBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, lbContext.width + 12, 1)];
        ivContentBg.tag = 100;
        [cell.contentView addSubview:ivContentBg];
        [cell.contentView addSubview:lbContext];
    }
    ASUrlImageView *ivFace = (ASUrlImageView *)[cell.contentView viewWithTag:99];
    UIImageView *ivContentBg = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *lbContext = (UILabel *)[cell.contentView viewWithTag:101];
    
    ASUSR_SMS *item = [self.list objectAtIndex:indexPath.row];
    [ivFace load:item.smallFromPhotoShow cacheDir:nil];
    lbContext.text = [item.Context copy];
    lbContext.height = [lbContext.text sizeWithFont:lbContext.font constrainedToSize:CGSizeMake(lbContext.width, CGFLOAT_MAX) lineBreakMode:lbContext.lineBreakMode].height;
    ivContentBg.height = lbContext.height + 12;
    if(item.FromSysNo == [ASGlobal shared].user.SysNo){//发出去的
        ivFace.origin = CGPointMake(10, 10);
        ivContentBg.origin = CGPointMake(ivFace.right + 6, ivFace.top);
    }else{
        ivFace.right = 310;
        ivFace.top = 10;
        ivContentBg.right = ivFace.left - 6;
        ivContentBg.top = ivFace.top;
    }
    lbContext.origin = CGPointMake(ivContentBg.left + 6, ivContentBg.top + 6);
    
    return cell;
}

@end
