//
//  ASAskDetailCellView.m
//  astro
//
//  Created by kjubo on 14-10-15.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPanView.h"
#import "ASQaAnswer.h"
#import "ASAskDetailCellView.h"

@interface ASAskDetailCellView ()
@property (nonatomic, strong) ASUrlImageView *faceView; //头像
@property (nonatomic, strong) UILabel *lbName;  //昵称 等级
@property (nonatomic, strong) UILabel *lbFloor; //楼
@property (nonatomic, strong) UILabel *lbPostIntro;  //提问数 & 反馈数
@property (nonatomic, strong) UILabel *lbDate;  //发布时间
@property (nonatomic, strong) UIImageView *ivShangBg;   //奖励层
@property (nonatomic, strong) UILabel *lbShang1;
@property (nonatomic, strong) UILabel *lbShang2;

@property (nonatomic, strong) ASPanView *panView;
@property (nonatomic, strong) UILabel *lbReViewInfo;//浏览数回复数
@property (nonatomic, strong) UIButton *btnComment; //评论
@property (nonatomic, strong) UIButton *btnDelete;  //删除
@property (nonatomic, strong) UITableView *tbComment;//评论列表
@property (nonatomic, strong) UIButton *btnMore; //更多评论
@property (nonatomic, weak) ASQaAnswer *answer;
@end

@implementation ASAskDetailCellView
- (id)initWithFrame:(CGRect)frame
{
    CGFloat margin = 10;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        self.faceView = [[ASUrlImageView alloc] initWithFrame:CGRectMake(margin, margin, 30, 30)];
        [self addSubview:self.faceView];
        
        self.lbName = [self newLabel:CGRectMake(self.faceView.right + margin, margin, 200, 15)];
        [self addSubview:self.lbName];
        
        self.lbPostIntro = [self newLabel:CGRectMake(self.lbName.left, self.lbName.bottom + 2, 200, 15)];
        [self addSubview:self.lbPostIntro];
        
        self.lbFloor = [self newLabel:CGRectMake(0, self.lbName.top, 0, 15)];
        self.lbFloor.font = [UIFont systemFontOfSize:12];
        self.lbFloor.textColor = [UIColor whiteColor];
        self.lbFloor.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lbFloor];
        
        self.lbDate = [self newLabel:CGRectMake(0, self.lbPostIntro.top, 80, 15)];
        self.lbDate.textAlignment = NSTextAlignmentRight;
        self.lbDate.right = self.width - margin;
        [self addSubview:self.lbDate];
        
        self.ivShangBg = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 0, 240, 26)];
        UIImage *img = [UIImage imageNamed:@"lingqian_bg"];
        self.ivShangBg.image = [img stretchableImageWithLeftCapWidth:img.size.width/2 + 5 topCapHeight:0];
        [self addSubview:self.ivShangBg];
        
        self.lbShang1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60, 20)];
        self.lbShang1.backgroundColor = [UIColor whiteColor];
        self.lbShang1.font = [UIFont systemFontOfSize:14];
        self.lbShang1.textColor = [UIColor blackColor];
        self.lbShang1.textAlignment = NSTextAlignmentCenter;
        self.lbShang1.centerY = self.ivShangBg.height/2;
        [self.ivShangBg addSubview:self.lbShang1];
        
        self.lbShang2 = [[UILabel alloc] initWithFrame:CGRectMake(self.lbShang1.right + 10, 0, 60, 20)];
        self.lbShang2.backgroundColor = [UIColor whiteColor];
        self.lbShang2.font = [UIFont systemFontOfSize:14];
        self.lbShang2.textAlignment = NSTextAlignmentCenter;
        self.lbShang2.centerY = self.ivShangBg.height/2;
        [self.ivShangBg addSubview:self.lbShang2];
        
        self.panView = [[ASPanView alloc] initWithFrame:CGRectMake(margin, self.lbPostIntro.bottom + 5, self.width - 2*margin, 0)];
        [self addSubview:self.panView];
        
        self.btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.btnDelete setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
        [self.btnDelete addTarget:self action:@selector(btnClick_delete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnDelete];
        
        self.btnComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.btnComment setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [self addSubview:self.btnComment];
        
        self.lbReViewInfo = [self newLabel:CGRectMake(self.faceView.left, 0, 200, 20)];
        [self addSubview:self.lbReViewInfo];
        
        self.tbComment = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1) style:UITableViewStylePlain];
        self.tbComment.backgroundColor = UIColorFromRGB(0xe0ecd1);
        self.tbComment.scrollEnabled = NO;
        self.tbComment.delegate = self;
        self.tbComment.dataSource = self;
        self.tbComment.separatorColor = [UIColor clearColor];
        self.tbComment.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tbComment];
        
        self.btnMore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tbComment.width - 20, 28)];
        self.btnMore.layer.cornerRadius = 5.0;
        self.btnMore.centerX = self.tbComment.centerX;
        self.btnMore.backgroundColor = UIColorFromRGB(0x779058);
        self.btnMore.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnMore.hidden = YES;
        [self addSubview:self.btnMore];
    }
    return self;
}

- (UILabel *)newLabel:(CGRect)frame{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:13];
    return lb;
}

- (void)setQaProtocol:(id<ASQaProtocol>)qa canDel:(BOOL)canDel canComment:(BOOL)canComment floor:(NSInteger)floor{
    ASCustomerShow *user = [qa Customer];
    [self.faceView load:user.smallPhotoShow cacheDir:NSStringFromClass([ASCustomerShow class])];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:user.NickName
                                                                            attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t等级 "]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:user.GradeShow
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    self.lbName.attributedText = str;
    self.lbFloor.text = [NSString stringWithFormat:@" %d楼 ", floor];
    [self.lbFloor sizeToFit];
    self.lbFloor.top = self.faceView.top;
    self.lbFloor.right = self.lbDate.right;
    
    str = [[NSMutableAttributedString alloc] initWithString:@"提问数 "];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:Int2String(user.TotalQuest)
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" | 反馈数 "]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:Int2String(user.TotalReply)
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    self.lbPostIntro.attributedText = str;
    self.lbDate.text = [[qa TS] toStrFormat:@"yyyy-MM-dd"];
    
    CGFloat top = self.lbPostIntro.bottom + 5;
    if(floor == 1){
        self.ivShangBg.hidden = NO;
        self.ivShangBg.top = top;
        self.lbShang1.text = [NSString stringWithFormat:@"%d 灵签", [qa Award]];
        if([qa IsEnd]){
            self.lbShang2.textColor = [UIColor redColor];
            self.lbShang2.text = @"已结束";
        }else{
            self.lbShang2.textColor = ASColorBlueGreen;
            self.lbShang2.text = @"进行中";
        }
        top = self.ivShangBg.bottom + 5;
    }else{
        self.ivShangBg.hidden = YES;
    }
    
    self.panView.top = top;
    NSArray *chart = nil;
    if([qa respondsToSelector:@selector(Chart)]){
        chart = [qa Chart];
    }
    [self.panView setChart:chart context:[qa Context]];
    
    if(floor == 1){
        self.lbReViewInfo.hidden = NO;
        str = [[NSMutableAttributedString alloc] initWithString:@"浏览数 "];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:Int2String([qa ReadCount])
                                                                    attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" | 回复数 "]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:Int2String([qa ReplyCount])
                                                                    attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
        self.lbReViewInfo.attributedText = str;
        self.lbReViewInfo.top = self.panView.bottom + 5;
        top = self.lbReViewInfo.bottom + 5;
    }else{
        self.lbReViewInfo.hidden = YES;
    }

    CGFloat btnRight = self.lbDate.right;
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
        top = self.panView.bottom + 30;
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
    
    self.height = top;
}

- (void)btnClick_delete:(UIButton *)sender{
    
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

+ (CGFloat)heightForQaProtocol:(id<ASQaProtocol>)qa{
    CGFloat height = 75;
    NSArray *chart = nil;
    if([qa respondsToSelector:@selector(Chart)]){
        chart = [qa Chart];
    }
    height += [ASPanView heightForChart:chart context:[qa Context]];
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
