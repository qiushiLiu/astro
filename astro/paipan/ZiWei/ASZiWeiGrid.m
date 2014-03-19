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
@property (nonatomic, strong)NSMutableParagraphStyle *paragraphStyle;
@property (nonatomic, strong)NSDictionary *rAttribute;
@property (nonatomic, strong)NSDictionary *wAttribute;
@property (nonatomic, strong)NSMutableArray *stars;
@property (nonatomic, strong)NSMutableArray *starsIndex;
@property (nonatomic)NSInteger gongIndex;

//宫名
@property (nonatomic, strong) UILabel *lbGongName;
//当令
@property (nonatomic, strong) UILabel *lbTransit;
@end

#define ZWColorBlue UIColorFromRGB(0x26ae6)
#define ZWColorRed UIColorFromRGB(0xff3301)
#define ZWColorGreen UIColorFromRGB(0x038516)
#define ZWColorFu UIColorFromRGB(0xfe02d1)
#define ZWColorXiong UIColorFromRGB(0x6700e6)
#define ZWColorXiao UIColorFromRGB(0x9c552d)
#define ZWColorGray UIColorFromRGB(0x646464)

#define __CellSize CGSizeMake(80, 140)
#define __LineCount 6
#define __FontSize 13
#define __TextFont 10.5

@implementation ASZiWeiGrid

+ (NSMutableArray *)cellAuchor{
    static NSMutableArray *_cellAuchor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellAuchor = [[NSMutableArray alloc] init];
        // 0 - 3
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __CellSize.height * 3)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __CellSize.height * 2)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, __CellSize.height)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
        
        // 4 - 6
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 1, 0)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 2, 0)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, 0)]];
        
        // 7 - 9
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, __CellSize.height)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, __CellSize.height * 2)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, __CellSize.height * 3)]];
        
        // 10 - 11
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 2, __CellSize.height * 3)]];
        [_cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 1, __CellSize.height * 3)]];
    });
    return _cellAuchor;
}

- (id)initWithGong:(ZiWeiGong *)gong index:(NSInteger)gongIndex
{
    self = [super initWithFrame:CGRectMake(0, 0, __CellSize.width, __CellSize.height)];
    if (self) {
        // Initialization code
        self.paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        self.paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        self.paragraphStyle.alignment = NSTextAlignmentCenter;
        
        self.rAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorRed,NSParagraphStyleAttributeName : self.paragraphStyle};
        self.wAttribute = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:__TextFont], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : self.paragraphStyle};
        
        self.layer.borderColor = ASColorDarkGray.CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor clearColor];


        self.gongIndex = gongIndex;
        self.gong = gong;
        self.stars = [[NSMutableArray alloc] init];
        self.starsIndex = [[NSMutableArray alloc] init];
        self.origin = [[[self class].cellAuchor objectAtIndex:self.gongIndex] CGPointValue];
        
        self.lbGongName = [self newLabel];
        self.lbGongName.centerX = self.width/2 + 5;
        self.lbGongName.bottom = self.height - 4;
        [self addSubview:self.lbGongName];
        
        self.lbTransit = [self newLabel];
        self.lbTransit.centerX = self.width/2 + 5;
        self.lbTransit.bottom = self.lbGongName.top - 2;
        [self addSubview:self.lbTransit];
        
        NSMutableAttributedString *tran = nil;
        if(self.gong.TransitA > 0){
            tran = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02d-%02d", self.gong.TransitA, self.gong.TransitB]];
            [tran addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:__TextFont],
                                  NSParagraphStyleAttributeName : self.paragraphStyle,
                                  NSForegroundColorAttributeName : ZWColorGray,
                                  } range:NSMakeRange(0, tran.length)];
        }
        self.lbTransit.attributedText = tran;
    }
    return self;
}

- (void)setGongName:(NSString *)gongName{
    _gongName = [gongName copy];
    if(self.selected){
        self.lbGongName.attributedText = [[NSAttributedString alloc] initWithString:_gongName attributes:self.wAttribute];
        self.lbGongName.backgroundColor = [UIColor redColor];
    }else{
        self.lbGongName.attributedText = [[NSAttributedString alloc] initWithString:_gongName attributes:self.rAttribute];
        self.lbGongName.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.gongName = self.gongName;
}

- (void)addStar:(ZiWeiStar *)star withIndex:(NSInteger)index;
{
    [self.stars addObject:star];
    [self.starsIndex addObject:@(index)];
    [self setNeedsDisplay];
}

- (UILabel *)newLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __FontSize * 3, __FontSize)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:__TextFont];
    return lb;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    NSDictionary *bAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : [UIColor blackColor],NSParagraphStyleAttributeName : self.paragraphStyle};
    NSDictionary *xAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorXiao,NSParagraphStyleAttributeName : self.paragraphStyle};
    
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
        int endIndex = -1;
        if(i < __LineCount){
            p.x = self.width - 1.5 - __FontSize * (i + 1);
            p.y = 2;
            NSMutableAttributedString *miaoWang = [[NSMutableAttributedString alloc] initWithString:[__ZiWeiMiaowang objectAtIndex:star.Wang]];
            if(![[miaoWang mutableString] isEqualToString:@" "]){
                [miaoWang addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont],
                                          NSForegroundColorAttributeName : [UIColor blackColor],
                                          NSParagraphStyleAttributeName : self.paragraphStyle,
                                          } range:NSMakeRange(0, miaoWang.length)];
                [miaoWang drawInRect:CGRectMake(p.x, p.y + __FontSize * 2, __FontSize, __FontSize)];
            }
            
            NSMutableAttributedString *siHua = [[NSMutableAttributedString alloc] initWithString:[__ZiWeiSihua objectAtIndex:star.Hua]];
            if(![[siHua mutableString] isEqualToString:@" "]){
                endIndex = i;
                [siHua addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSParagraphStyleAttributeName : self.paragraphStyle,
                                       } range:NSMakeRange(0, siHua.length)];
                CGRect siHuaRect = CGRectMake(p.x, p.y + __FontSize * 3, __FontSize, __FontSize);
                [[UIColor redColor] setFill];
                UIRectFill(siHuaRect);
                [siHua drawInRect:siHuaRect];
            }
        }else{
            if(endIndex >= 0
               && (__LineCount - endIndex) == (i - __LineCount)){   //第二行星体占用了第三行文字则停止排星
                break;
            }
            
            p.x = 1.5 + __FontSize * (i - __LineCount);
            p.y = 2 + __FontSize * 3;
        }
        
        NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:[__ZiWeiStar objectAtIndex:star.StarName]];
        [name addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont],
                              NSForegroundColorAttributeName : cl,
                              NSParagraphStyleAttributeName : self.paragraphStyle,
                              } range:NSMakeRange(0, name.length)];
        [name drawInRect:CGRectMake(p.x, p.y, __FontSize, __FontSize * 2)];
    }
    
    p = CGPointMake(2, self.height - 4);
    // 将前
    // 太岁
    // 博士
    NSAttributedString *boShi = [[NSAttributedString alloc] initWithString:[__ZiWeiBoShi objectAtIndex:self.gong.BoShi] attributes:bAttribute];
    NSAttributedString *taiSui = [[NSAttributedString alloc] initWithString:[__ZiWeiBoShi objectAtIndex:self.gong.TaiSui] attributes:bAttribute];
    NSAttributedString *jianQian = [[NSAttributedString alloc] initWithString:[__ZiWeiJiangQian objectAtIndex:self.gong.JiangQian] attributes:bAttribute];
    [jianQian drawInRect:CGRectMake(p.x, p.y - 3 * __FontSize, __FontSize * 2, __FontSize)];
    [boShi drawInRect:CGRectMake(p.x, p.y - __FontSize, __FontSize * 2, __FontSize)];
    [taiSui drawInRect:CGRectMake(p.x , p.y - 2 * __FontSize, __FontSize * 2, __FontSize)];
    
    p = CGPointMake(self.width - 2 - __FontSize, self.height - 4);
    //天干地支
    //长生
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", [__TianGan objectAtIndex:self.gong.TG], [__DiZhi objectAtIndex:self.gong.DZ], [__ZiWeiChangSheng objectAtIndex:self.gong.ChangSheng]]];
    [str addAttributes:bAttribute range:NSMakeRange(0, 2)];
    [str addAttributes:xAttribute range:NSMakeRange(2, str.length - 2)];
    [str drawInRect:CGRectMake(p.x, p.y - str.length * __FontSize, __FontSize, __FontSize * str.length)];
}

@end
