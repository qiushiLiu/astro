//
//  ASAskDetailCell.m
//  astro
//
//  Created by kjubo on 14-6-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskDetailCell.h"
#import "ASPanView.h"
#import "ASQaAnswer.h"
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
@property (nonatomic, strong) UIButton *btnMore; //更多评论
@property (nonatomic, weak) ASQaAnswer *answer;
@end

@implementation ASAskDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat margin = 10;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, self.width - 2*margin, 0)];
        self.bgView.clipsToBounds = YES;
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
        
        self.tbComment = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, 1) style:UITableViewStylePlain];
        self.tbComment.backgroundColor = UIColorFromRGB(0xe0ecd1);
        self.tbComment.scrollEnabled = NO;
        self.tbComment.delegate = self;
        self.tbComment.dataSource = self;
        self.tbComment.separatorColor = [UIColor clearColor];
        self.tbComment.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.bgView addSubview:self.tbComment];
        
        self.btnMore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tbComment.width - 20, 28)];
        self.btnMore.layer.cornerRadius = 5.0;
        self.btnMore.centerX = self.tbComment.centerX;
        self.btnMore.backgroundColor = UIColorFromRGB(0x779058);
        self.btnMore.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnMore.hidden = YES;
        [self.bgView addSubview:self.btnMore];
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
    
    CGFloat top = 0;
    if(canDel || canComment){
        top = self.panView.bottom + 30;
    }else{
        top = self.panView.bottom + 10;
    }
    
    self.tbComment.hidden = YES;
    self.btnMore.hidden = YES;
    if([qa isKindOfClass:[ASQaAnswer class]]){
        self.answer = (ASQaAnswer *)qa;
        if([self.answer.TopComments count] > 0){
            self.tbComment.hidden = NO;
            [self.tbComment reloadData];
            self.tbComment.height = self.tbComment.contentSize.height;
            self.tbComment.top = top;
            top = self.tbComment.bottom;
        }
        if(self.answer.HasMoreComment){
            self.btnMore.hidden = NO;
            self.btnMore.top = self.tbComment.bottom + 3;
            top = self.btnMore.bottom + 10;
            self.tbComment.height = top;
            [self.btnMore setTitle:[NSString stringWithFormat:@"更多%d条评论+", self.answer.ToalComment] forState:UIControlStateNormal];
        }
    }
    
    self.bgView.height = top;
    self.height = self.bgView.height + 10;
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.answer){
        return [self.answer.TopComments count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.answer){
        ASQaComment *comment = [self.answer.TopComments objectAtIndex:indexPath.row];
        return [[self class] heightForComment:comment];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASQaAnswerCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ASQaAnswerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        ASUrlImageView *fv = [[ASUrlImageView alloc] initWithFrame:CGRectMake(15, 6, 30, 30)];
        fv.tag = 100;
        [cell.contentView addSubview:fv];
        
        UILabel *lb = [self newLabel:CGRectMake(fv.right + 5, fv.top, 230, 0)];
        lb.tag = 200;
        lb.numberOfLines = 0;
        lb.font = [UIFont systemFontOfSize:12];
        lb.lineBreakMode = NSLineBreakByCharWrapping;
        [cell.contentView addSubview:lb];
    }
    
    ASUrlImageView *fv = (ASUrlImageView *)[cell.contentView viewWithTag:100];
    UILabel *lb = (UILabel *)[cell.contentView viewWithTag:200];
    
    if(self.answer){
        ASQaComment *comment = [self.answer.TopComments objectAtIndex:indexPath.row];
        [fv load:comment.Customer.smallPhotoShow cacheDir:NSStringFromClass([ASCustomer class])];
        lb.text = [comment.Context copy];
        lb.height = [lb.text sizeWithFont:lb.font constrainedToSize:CGSizeMake(lb.width, CGFLOAT_MAX) lineBreakMode:lb.lineBreakMode].height;
    }
    
    return cell;
}

+ (CGFloat)heightForComment:(ASQaComment *)as{
    CGFloat height = 10 + [as.Context sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(230, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    height = MAX(35, height);
    height += 5;
    return height;
}

+ (CGFloat)heightForQaProtocol:(id<ASQaBaseProtocol>)qa chart:(NSArray *)chart{
    CGFloat height = 95;
    height += [ASPanView heightForChart:chart context:qa.Context];
    if([qa isKindOfClass:[ASQaAnswer class]]){
        ASQaAnswer *as = (ASQaAnswer *)qa;
        for(ASQaComment *ct in as.TopComments){
            height += [[self class] heightForComment:ct];
        }
        if(as.HasMoreComment){
            height += 40;
        }
    }
    return height;
}

@end