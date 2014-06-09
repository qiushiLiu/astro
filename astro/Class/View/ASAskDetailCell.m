//
//  ASAskDetailCell.m
//  astro
//
//  Created by kjubo on 14-6-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskDetailCell.h"
#import "ASPanView.h"
@interface ASAskDetailCell ()
@property (nonatomic, strong) UIView *bgView;   //背景
@property (nonatomic, strong) ASUrlImageView *faceView; //头像
@property (nonatomic, strong) UILabel *lbName;  //昵称 等级
@property (nonatomic, strong) UILabel *lbFloor; //楼
@property (nonatomic, strong) UILabel *lbPostIntro;  //提问数 & 反馈数
@property (nonatomic, strong) UILabel *lbDate;  //发布时间
@property (nonatomic, strong) ASPanView *panView;
@property (nonatomic, strong) UIButton *btnComment; //评论
@property (nonatomic, strong) UIButton *btnDelete;  //删除
@property (nonatomic, strong) UITableView *tbComment;//评论列表
@end

@implementation ASAskDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat margin = 10;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, self.width - 2*margin, 0)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 6;
        self.bgView.layer.borderWidth = 1;
        self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:self.bgView];
        
        self.faceView = [[ASUrlImageView alloc] initWithFrame:CGRectMake(margin, margin, 30, 30)];
        [self.bgView addSubview:self.faceView];
        
        self.lbName = [self newLabel:CGRectMake(self.faceView.right + margin, margin, 200, 15)];
        [self.bgView addSubview:self.lbName];
        
        self.lbPostIntro = [self newLabel:CGRectMake(self.lbName.left, self.lbName.bottom + 2, 200, 15)];
        [self.bgView addSubview:self.lbPostIntro];
        
        self.lbFloor = [self newLabel:CGRectMake(0, self.lbName.top, 60, 15)];
        self.lbFloor.textAlignment = NSTextAlignmentRight;
        self.lbFloor.right = self.bgView.width - margin;
        [self.bgView addSubview:self.lbFloor];
        
        self.lbDate = [self newLabel:CGRectMake(0, self.lbPostIntro.top, 80, 15)];
        self.lbDate.textAlignment = NSTextAlignmentRight;
        self.lbDate.right = self.bgView.width - margin;
        [self.bgView addSubview:self.lbDate];
        
        self.panView = [[ASPanView alloc] initWithFrame:CGRectMake(margin, self.lbPostIntro.bottom + 5, self.bgView.width - 2*margin, 0)];
        [self.bgView addSubview:self.panView];
        
        self.btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.btnDelete setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
        [self.bgView addSubview:self.btnDelete];
        
        self.btnComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.btnComment setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [self.bgView addSubview:self.btnComment];
        
        self.tbComment = [[UITableView alloc] initWithFrame:self.bgView.frame style:UITableViewStylePlain];
        self.tbComment.delegate = self;
        self.tbComment.dataSource = self;
        self.tbComment.separatorColor = [UIColor clearColor];
        self.tbComment.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.bgView addSubview:self.tbComment];
    }
    return self;
}

- (UILabel *)newLabel:(CGRect)frame{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:14];
    return lb;
}

- (void)setQaProtocol:(id<ASQaBaseProtocol>)qa chart:(NSArray *)chart customer:(ASCustomerShow *)user canDel:(BOOL)canDel canComment:(BOOL)canComment{
    [self.faceView load:user.smallPhotoShow cacheDir:NSStringFromClass([ASCustomerShow class])];
    
    NSString *temp = [NSString stringWithFormat:@"%@\t等级 ", user.NickName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:temp];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:Int2String(2)
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    self.lbName.attributedText = str;
    
    str = [[NSMutableAttributedString alloc] initWithString:@"提问数"];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:Int2String(user.TotalQuest)
                                                               attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" | 反馈数"]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:Int2String(user.TotalReply)
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    self.lbPostIntro.attributedText = str;
    
    self.lbDate.text = [[qa TS] toStrFormat:@"yyyy-MM-dd"];
    [self.panView setChart:chart context:[qa Context]];
    
    CGFloat btnRight = self.bgView.right - 10;
    if(canDel){
        self.btnDelete.hidden = NO;
        self.btnDelete.right = btnRight;
        self.btnDelete.top = self.panView.bottom;
        btnRight = self.btnDelete.left - 5;
    }else{
        self.btnDelete.hidden = YES;
    }
    
    if(canComment){
        self.btnComment.hidden = NO;
        self.btnComment.right = btnRight;
        self.btnComment.top = self.panView.bottom;
        btnRight = self.btnComment.left - 5;
    }else{
        self.btnComment.hidden = YES;
    }
    
    if(canDel || canComment){
        self.bgView.height = self.panView.bottom + 30;
    }else{
        self.bgView.height = self.panView.bottom + 10;
    }
    
    
    self.height = self.bgView.height + 10;
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

+ (CGFloat)heightForQaProtocol:(id<ASQaBaseProtocol>)qa chart:(NSArray *)chart{
    CGFloat height = 115;
    height += [ASPanView heightForChart:chart context:qa.Context];
    return height;
}

@end
