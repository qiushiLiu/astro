//
//  ASZiWeiGrid.m
//  astro
//
//  Created by kjubo on 14-3-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASZiWeiGrid.h"
#import "Paipan.h"

@interface ASZiWeiGrid ()
@property (nonatomic, strong) NSDictionary *rAttribute;
@property (nonatomic, strong) NSDictionary *wAttribute;
@property (nonatomic, strong) NSMutableArray *stars;
@property (nonatomic, strong) NSMutableArray *starsIndex;
@property (nonatomic, strong) NSMutableArray *liuYao;
@property (nonatomic, strong) NSMutableArray *yunYao;
@property (nonatomic) NSInteger gongIndex;
@property (nonatomic) NSInteger index;

//宫名控件
@property (nonatomic, strong) UILabel *lbGong;
@property (nonatomic, strong) UILabel *lbYunGong;
@property (nonatomic, strong) UILabel *lbLiuGong;
//当令
@property (nonatomic, strong) UILabel *lbTransit;

@property (nonatomic) UIEdgeInsets edge;
@end

@implementation ASZiWeiGrid

static NSMutableArray *cellAuchor = nil;
static NSMutableArray *lxCellAuchor = nil;
static NSMutableParagraphStyle *style = nil;
- (void)createStatic{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellAuchor = [[NSMutableArray alloc] init];
        // 0 - 3
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __CellSize.height * 3)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __CellSize.height * 2)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __CellSize.height)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
        
        // 4 - 6
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 1, 0)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 2, 0)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, 0)]];
        
        // 7 - 9
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, __CellSize.height)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, __CellSize.height * 2)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, __CellSize.height * 3)]];
        
        // 10 - 11
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 2, __CellSize.height * 3)]];
        [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 1, __CellSize.height * 3)]];
        
        lxCellAuchor = [[NSMutableArray alloc] init];
        // 0 - 3
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __LxCellSize.height * 3)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __LxCellSize.height * 2)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __LxCellSize.height)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
        
        // 4 - 6
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 1, 0)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 2, 0)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 3, 0)]];
        
        // 7 - 9
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 3, __LxCellSize.height)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 3, __LxCellSize.height * 2)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 3, __LxCellSize.height * 3)]];
        
        // 10 - 11
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 2, __LxCellSize.height * 3)]];
        [lxCellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__LxCellSize.width * 1, __LxCellSize.height * 3)]];
        
        style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentCenter;
        style.minimumLineHeight = __FontSize.height;
        style.maximumLineHeight = __FontSize.height;
    });
}

- (id)initWithZiWei:(ZiWeiMod *)mod index:(NSInteger)index lx:(BOOL)lx
{
    self.lx = lx;
    CGSize size = self.lx ? __LxCellSize : __CellSize;
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        [self createStatic];
        // Initialization code
        self.edge = UIEdgeInsetsMake(4, 4, 6, 4);
        self.backgroundColor = [UIColor clearColor];
        self.rAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorRed,NSParagraphStyleAttributeName : style};
        self.wAttribute = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:__TextFont], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : style};

        self.index = index;
        self.ziwei = mod;
        self.gong = [self.ziwei.Gong objectAtIndex:index];
        self.gongIndex = self.gong.GongName;
        self.stars = [[NSMutableArray alloc] init];
        self.starsIndex = [[NSMutableArray alloc] init];
        self.liuYao = [[NSMutableArray alloc] init];
        self.yunYao = [[NSMutableArray alloc] init];
        if(self.lx){
            self.origin = [[lxCellAuchor objectAtIndex:self.gongIndex] CGPointValue];
        }else{
            self.origin = [[cellAuchor objectAtIndex:self.gongIndex] CGPointValue];
        }
        
        CGFloat centerX = self.width/2 + 5;
        CGFloat bottom = self.height - self.edge.bottom - 0.5;
        if(self.lx){
            self.lbLiuGong = [self newLabel];
            self.lbLiuGong.centerX = centerX;
            self.lbLiuGong.bottom = bottom;
            [self addSubview:self.lbLiuGong];
            bottom = self.lbLiuGong.top;
            
            self.lbYunGong = [self newLabel];
            self.lbYunGong.centerX = centerX;
            self.lbYunGong.bottom = bottom;
            [self addSubview:self.lbYunGong];
            bottom = self.lbYunGong.top;
        }
        
        self.lbGong = [self newLabel];
        self.lbGong.centerX = centerX;
        self.lbGong.bottom = bottom;
        [self addSubview:self.lbGong];
        bottom = self.lbGong.top;
        
        self.lbTransit = [self newLabel];
        self.lbTransit.centerX = centerX;
        self.lbTransit.bottom = bottom;
        [self addSubview:self.lbTransit];
        
        NSMutableString *gn = [[NSMutableString alloc] initWithString:GetZiWeiGong(self.gongIndex)];
        if(self.ziwei.Shen == self.index){
            if(self.ziwei.Ming == self.index){
                [gn replaceCharactersInRange:NSMakeRange(0, 1) withString:@"命"];
            }
            [gn replaceCharactersInRange:NSMakeRange(1, 1) withString:@"★"];
            [gn replaceCharactersInRange:NSMakeRange(2, 1) withString:@"身"];
        }
        self.lbGong.text = gn;
        
        if(self.lx){
            [self.lbLiuGong setText:[NSString stringWithFormat:@"流%@", [GetZiWeiGong(self.gong.YunGongName) substringToIndex:2]]];
            [self.lbYunGong setText:[NSString stringWithFormat:@"运%@", [GetZiWeiGong(self.gong.LiuGongName) substringToIndex:2]]];
        }
        
        NSMutableAttributedString *tran = nil;
        if(self.gong.TransitA > 0){
            tran = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld-%02ld", self.gong.TransitA, self.gong.TransitB]];
            [tran addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:__TextFont],
                                  NSParagraphStyleAttributeName : style,
                                  NSForegroundColorAttributeName : ZWColorGray,
                                  } range:NSMakeRange(0, tran.length)];
        }
        self.lbTransit.attributedText = tran;
        
        self.selected = NO;
    }
    return self;
}

- (void)addYunYao:(int)tag{
    [self.yunYao addObject:[NSString stringWithFormat:@"运%@", [__ZiWeiLiuYao objectAtIndex:tag]]];
}

- (void)addLiuYao:(int)tag{
    [self.liuYao addObject:[NSString stringWithFormat:@"流%@", [__ZiWeiLiuYao objectAtIndex:tag]]];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(self.selected){
        self.lbGong.textColor = [UIColor whiteColor];
        [self.lbLiuGong setTextColor:[UIColor whiteColor]];
        [self.lbYunGong setTextColor:[UIColor whiteColor]];
        
        self.lbGong.backgroundColor = ZWColorRed;
        [self.lbLiuGong setBackgroundColor:ZWColorGreen];
        [self.lbYunGong setBackgroundColor:ZWColorBlue];
    }else{
        self.lbGong.textColor = ZWColorRed;
        [self.lbLiuGong setTextColor:ZWColorGreen];
        [self.lbYunGong setTextColor:ZWColorBlue];
        
        self.lbGong.backgroundColor = [UIColor clearColor];
        [self.lbLiuGong setBackgroundColor:[UIColor clearColor]];
        [self.lbYunGong setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)addStar:(ZiWeiStar *)star withIndex:(NSInteger)index;
{
    [self.stars addObject:star];
    [self.starsIndex addObject:@(index)];
    [self setNeedsDisplay];
}

- (UILabel *)newLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __FontSize.width * 3, __FontSize.height)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:__TextFont];
    lb.textAlignment = NSTextAlignmentCenter;
    return lb;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    NSDictionary *bAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : [UIColor blackColor],NSParagraphStyleAttributeName : style};
    NSDictionary *blAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorBlue, NSParagraphStyleAttributeName : style};
    NSDictionary *xAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorXiao,NSParagraphStyleAttributeName : style};
    NSDictionary *wAttribute = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:__TextFont], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : style};
    NSDictionary *gAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorGreen,NSParagraphStyleAttributeName : style};
    NSArray *hsColor = @[ZWColorRed, ZWColorGreen, ZWColorBlue];
    
    NSInteger line = 0;
    NSInteger maxline = self.lx ? 3 : 2;

    NSInteger linemax = __LineCount;
    NSInteger linebegin = 0;
    CGPoint p = CGPointZero;
    for(int i = 0; i < [self.stars count]; i++){
        int index = [[self.starsIndex objectAtIndex:i] intValue];
        ZiWeiStar *star = [self.stars objectAtIndex:i];
        UIColor *cl = nil;
        if(index <= 13){    //主星颜色
            cl = ZWColorRed;
        } else if(index <= 21){
            cl = ZWColorFu;
        } else if(index <= 27){
            cl = ZWColorXiong;
        } else{
            cl = ZWColorXiao;
        }
        if(i < __LineCount){
            p.x = self.width - self.edge.right - __FontSize.width * (i + 1);
            p.y = self.edge.top;
            NSMutableAttributedString *miaoWang = [[NSMutableAttributedString alloc] initWithString:[__ZiWeiMiaowang objectAtIndex:star.Wang]];
            if([miaoWang length] > 0){
                [miaoWang addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont],
                                          NSForegroundColorAttributeName : [UIColor blackColor],
                                          NSParagraphStyleAttributeName : style,
                                          } range:NSMakeRange(0, miaoWang.length)];
                [miaoWang drawInRect:CGRectMake(p.x, p.y + __FontSize.height * 2, __FontSize.width, __FontSize.height)];
            }
            
            NSArray *hs = @[@(star.Hua), @(star.YunHua), @(star.LiuHua)];
            NSInteger huaCount = self.lx ? [hs count] : 1;
            for(int j = 0; j < huaCount; j++){
                NSString *huaStr = [__ZiWeiSihua objectAtIndex:[[hs objectAtIndex:j] intValue]];
                if([huaStr length] == 0){
                    continue;
                }
                linemax = 6 - i + 1;
                NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] initWithString:huaStr attributes:wAttribute];
                CGRect rect = CGRectMake(p.x, p.y + __FontSize.height * (3 + j), __FontSize.width, __FontSize.height);
                [[hsColor objectAtIndex:j] setFill];
                UIRectFill(rect);
                [ret drawInRect:rect];
            }
        }else{
            line = 1;
            linebegin = 6;
            if(linemax == (i - linebegin)){   //第二行星体占用了第三行文字则停止排星
                line++;
                linebegin = i;
                if(line == maxline){
                    break;
                }
            }
            p.x = self.edge.left + __FontSize.width * (i - linebegin);
            if(line == 0){
                p.y = self.edge.top;
            }else if(line == 1){
                p.y = self.edge.top + __FontSize.height * 3;
            }else if(line == 2){
                p.y = self.edge.top + __FontSize.height * 5;
            }
        }
        NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:GetZiWeiStar(star.StarName)];
        [name addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont],
                              NSForegroundColorAttributeName : cl,
                              NSParagraphStyleAttributeName : style,
                              } range:NSMakeRange(0, name.length)];
        [name drawInRect:CGRectMake(p.x, p.y, __FontSize.width, __FontSize.height * 2)];
    }
    
    p = CGPointMake(self.edge.left, self.height - self.edge.bottom);
    // (月) 将前 太岁 博士
    NSAttributedString *boShi = [[NSAttributedString alloc] initWithString:[__ZiWeiBoShi objectAtIndex:self.gong.BoShi] attributes:bAttribute];
    NSAttributedString *taiSui = [[NSAttributedString alloc] initWithString:[__ZiWeiTaiSui objectAtIndex:self.gong.TaiSui] attributes:bAttribute];
    NSAttributedString *jianQian = [[NSAttributedString alloc] initWithString:[__ZiWeiJiangQian objectAtIndex:self.gong.JiangQian] attributes:bAttribute];
    [jianQian drawInRect:CGRectMake(p.x, p.y - 3 * __FontSize.height, __FontSize.width * 2, __FontSize.height)];
    [taiSui drawInRect:CGRectMake(p.x , p.y - 2 * __FontSize.height, __FontSize.width * 2, __FontSize.height)];
    [boShi drawInRect:CGRectMake(p.x, p.y - __FontSize.height, __FontSize.width * 2, __FontSize.height)];
    if(self.lx){
        NSMutableString *str = [[NSMutableString alloc] initWithString:GetNongliMonth((self.gongIndex - self.ziwei.LiuYueGong + 12) % 12 + 1)];
        if([str length] == 1){
            [str appendString:@"月"];
        }
        NSAttributedString *yue = [[NSAttributedString alloc] initWithString:str attributes:xAttribute];
        [yue drawInRect:CGRectMake(p.x, p.y - 4 * __FontSize.height, __FontSize.width * 2, __FontSize.height)];
    }
    
    p.x = self.width - self.edge.right - __FontSize.width;
    //天干地支
    //长生
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    ps.alignment = NSTextAlignmentCenter;
    ps.minimumLineHeight = __FontSize.height;
    ps.maximumLineHeight = __FontSize.height;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", [__TianGan objectAtIndex:self.gong.TG], [__DiZhi objectAtIndex:self.gong.DZ], [__ZiWeiChangSheng objectAtIndex:self.gong.ChangSheng]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSParagraphStyleAttributeName : ps}];
    [str addAttributes:@{NSForegroundColorAttributeName : ZWColorXiao} range:NSMakeRange(2, str.length - 2)];
    [str drawInRect:CGRectMake(p.x, p.y - str.length * __FontSize.height, __FontSize.width, __FontSize.height * str.length)];
    
    if(self.lx){
        CGPoint plx = CGPointMake(p.x, p.y - __FontSize.height * 6);
        int count = 0;
        for(int i = 0; i < [self.liuYao count] || i < [self.yunYao count]; i++){
            if(i < [self.liuYao count]){
                if(count == 4){
                    break;
                }
                str = [[NSMutableAttributedString alloc] initWithString:[self.liuYao objectAtIndex:i] attributes:gAttribute];
                [str drawInRect:CGRectMake(plx.x, plx.y, __FontSize.width, __FontSize.height * 2)];
                plx.x -= __FontSize.width;
                count++;
            }
            if(i < [self.yunYao count]){
                if(count == 4){
                    break;
                }
                str = [[NSMutableAttributedString alloc] initWithString:[self.yunYao objectAtIndex:i] attributes:blAttribute];
                [str drawInRect:CGRectMake(plx.x, plx.y, __FontSize.width, __FontSize.height * 2)];
                plx.x -= __FontSize.width;
                count++;
            }
        }
    }
    
    //边框
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetStrokeColorWithColor(ctx, ASColorDarkGray.CGColor);
    if(self.gongIndex >=3 && self.gongIndex <= 6){
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, self.width, 0);
    }
    CGContextMoveToPoint(ctx, self.width, 0);
    CGContextAddLineToPoint(ctx, self.width, self.height);
    CGContextAddLineToPoint(ctx, 0, self.height);
    CGContextStrokePath(ctx);
}

@end
