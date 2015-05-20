//
//  ASDiceView.m
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASDiceView.h"
#import "ASDiceHouseView.h"
#import <QuartzCore/CATransform3D.h>

#define ILTransform2Angle(transform) atan2(transform.b, transform.a)
#define kVelocity M_PI * 0.3
#define kSeziDuration 0.4

@interface ASDiceView ()
@property (nonatomic, strong) UIImageView *cycleView;
@property (nonatomic, strong) UIImageView *ivSezi;  //色字
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) NSMutableArray *houses;
@property (nonatomic) CGFloat startSpeed;
@property (nonatomic) CGFloat speed;
@property (nonatomic) BOOL isFront;     //中间色子的正反面

@end

@implementation ASDiceView

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.houses = [NSMutableArray array];
        
        self.cycleView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.cycleView.image = [UIImage imageNamed:@"astro_xz"];
        [self addSubview:self.cycleView];
        
        CGFloat perAngle = M_PI / 6.0;
        CGFloat r1 = self.width/2 - 100;
        CGPoint center = CGPointMake(self.width/2, self.height/2);
        for(NSInteger i = 0; i < 12; i++){
            CGFloat ang = perAngle * i;
            ASDiceHouseView *houseView = [ASDiceHouseView houseView:i + 1];
            houseView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2 + ang);
            houseView.center = CGPointMake(center.x + r1 *cosf(ang + M_PI), center.y + r1 * sinf(ang + M_PI));
            [self addSubview:houseView];
            [self.houses addObject:houseView];
        }
        
        self.ivSezi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
        self.ivSezi.center = center;
        [self addSubview:self.ivSezi];
        
        _animateing = NO;
        _isFront = YES;
        _star = arc4random()%12;
        self.ivSezi.image = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_xing_%@", @(self.star)]] toImage:[UIImage imageNamed:@"dice_126"]];
    }
    return self;
}

- (NSInteger)constellation{
    CGFloat angle = ILTransform2Angle(self.cycleView.transform);
    return angle * 6.0 / M_PI + 6;
}

- (void)setStar:(NSInteger)star{
    if(_star == star){
        _star = (star + 1)%12;
    }else{
        _star = star;
    }
}

- (void)start{
    if(_animateing) return;
    
    self.userInteractionEnabled = NO;
    self.startSpeed = ((arc4random() % 101) + 200) * 0.01 * M_PI;
    self.speed = self.startSpeed;
    _animateing = YES;
    [self startRotate];
}

#pragma mark 供控制器调用,让圆转盘,开始慢悠悠地转
- (void)startRotate
{
    // NSTimer        只适合做频率比较低的事情
    // CADisplayLink  适合做频率比较高的事情
    if (_timer.isPaused) {
        // 如果CADisplayLink仅仅是暂停状态,那么取消暂停
        _timer.paused = NO;
    } else {
        // 先停止旧的 CADisplayLink
        [_timer invalidate];
        // 再创建新的 CADisplayLink,每1/60秒,调用一次self的rotating:方法
        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotating:)];
        [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    [self animateSezi];
}

- (void)setGong:(NSInteger)gong{
    if(gong < 0){
        gong = 11;
    }
    if(_gong == gong) return;
    ASDiceHouseView *hv0 = self.houses[_gong];
    ASDiceHouseView *hv1 = self.houses[gong];
    
    hv0.selected = NO;
    hv1.selected = YES;
    _gong = gong;
}

- (void)rotating:(CADisplayLink *)timer
{
    CGFloat angle = ILTransform2Angle(self.cycleView.transform);
    self.gong = -angle * 6.0 / M_PI + 6;
    CGFloat angledelta = self.speed * timer.duration - 0.5 * (self.startSpeed/3.0) * timer.duration * timer.duration;
    self.speed -= kVelocity * timer.duration;
    // 旋转一定的角度
    self.cycleView.transform = CGAffineTransformRotate(self.cycleView.transform, angledelta);
    if(self.speed <= 0){
        [self stopRotate];
    }
}

-(void)animateSezi
{
    if(!self.animateing) return;
    NSInteger direction = arc4random()%5;       //5个方向
    NSInteger lastStar = self.star;
    self.star = arc4random()%12;
    
    NSString *rootImageName = self.isFront ? @"dice_127" : @"dice_126";
    UIImage *ann1 = [self.ivSezi.image copy];
    UIImage *ann2 = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@", @(direction*12 + lastStar)]];
    UIImage *ann3 = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@", @(121 + direction)]];
    UIImage *ann4 = [UIImage imageNamed:[NSString stringWithFormat:@"dice_%@", @((direction + 5)*12 + self.star)]];
    UIImage *ann5 = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"dice_xing_%@", @(self.star)]] toImage:[UIImage imageNamed:rootImageName]];

    self.ivSezi.animationImages = @[ann1, ann2, ann3, ann4, ann5];
    self.ivSezi.animationDuration = 0.3;
    self.ivSezi.animationRepeatCount = 1;
    [self.ivSezi startAnimating];
    self.ivSezi.image = ann5;
    self.isFront = !self.isFront;
    
    [self performSelector:@selector(animateSezi) withObject:nil afterDelay:1.0];
}

// 计时器暂停,便可以暂停圆盘的旋转
- (void)pauseRotate
{
    // 暂停计时器 CADisplayLink
    _timer.paused = YES;
}

// 停止圆盘的转动,并且清空计时器
- (void)stopRotate
{
    _animateing = NO;
    [self.ivSezi stopAnimating];
    [_timer invalidate];
    _timer = nil;
    self.ivSezi.layer.transform = CATransform3DIdentity;
    if([self.delegate respondsToSelector:@selector(didFinishedDiceView:)]){
        [self.delegate didFinishedDiceView:self];
    }
}

- (UIImage *)addImage:(UIImage *)topImage toImage:(UIImage*)rootImage{
    UIGraphicsBeginImageContext(rootImage.size);
    CGFloat x = (rootImage.size.width - topImage.size.width)/2;
    CGFloat y = (rootImage.size.height - topImage.size.height)/2;
    [rootImage drawInRect:CGRectMake(0, 0, rootImage.size.width, rootImage.size.height)];
    [topImage drawInRect:CGRectMake(x, y, topImage.size.width, topImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
