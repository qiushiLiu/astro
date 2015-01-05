//
//  ASDiceView.m
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASDiceView.h"
#import "ASDiceHouseView.h"

#define ILTransform2Angle(transform) atan2(transform.b, transform.a)
#define kMax_Speed M_PI * 2
#define kVelocity M_PI * 0.3

@interface ASDiceView ()
@property (nonatomic, strong) UIView *cycleView;
@property (nonatomic, strong) UIImageView *ivConstellation;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) NSMutableArray *houses;
@property (nonatomic) CGFloat speed;
@end

@implementation ASDiceView

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.houses = [NSMutableArray array];
        
        self.cycleView = [[UIView alloc] initWithFrame:self.bounds];
        self.cycleView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cycleView];
        
        CGFloat perAngle = M_PI / 6.0;
        CGFloat r0 = self.width/2 - 15;
        CGFloat r1 = r0 - 50;
        CGPoint center = CGPointMake(self.width/2, self.height/2);
        for(NSInteger i = 0; i < 12; i++){
            CGFloat ang = perAngle * i;
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_cons_%@", @(i + 1)]]];
            iv.transform = CGAffineTransformRotate(CGAffineTransformIdentity, ang);
            iv.center = CGPointMake(center.x + r0 *cosf(ang - M_PI_2), center.y + r0 * sinf(ang - M_PI_2));
            [self.cycleView addSubview:iv];
            
            ASDiceHouseView *houseView = [ASDiceHouseView houseView:i + 1];
            houseView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2 + ang);
            houseView.center = CGPointMake(center.x + r1 *cosf(ang + M_PI), center.y + r1 * sinf(ang + M_PI));
            [self addSubview:houseView];
            [self.houses addObject:houseView];
        }
        
        self.ivConstellation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dice_1"]];
        self.ivConstellation.center = center;
        [self addSubview:self.ivConstellation];
        
    }
    return self;
}

- (void)start{
    [self stopRotate];
    self.userInteractionEnabled = NO;
    self.speed = kMax_Speed;
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
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if(_selectedIndex == selectedIndex) return;
    
    ASDiceHouseView *hv0 = self.houses[_selectedIndex];
    ASDiceHouseView *hv1 = self.houses[selectedIndex];
    
    hv0.selected = NO;
    hv1.selected = YES;
    _selectedIndex = selectedIndex;
}

- (void)rotating:(CADisplayLink *)timer
{
    CGFloat angle = ILTransform2Angle(self.cycleView.transform);
    self.selectedIndex = angle * 6.0 / M_PI + 6;
    CGFloat angledelta = self.speed * timer.duration - 0.5 * (kMax_Speed/3.0) * timer.duration * timer.duration;
    self.speed -= kVelocity * timer.duration;
    // 旋转一定的角度
    self.cycleView.transform = CGAffineTransformRotate(self.cycleView.transform, angledelta);
    if(self.speed <= 0){
        [self stopRotate];
    }
    self.ivConstellation.layer.transform = CATransform3DRotate(self.ivConstellation.layer.transform, M_PI_4, 0.0, 1.0, 1.0);
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
    [_timer invalidate];
    _timer = nil;
}

@end
