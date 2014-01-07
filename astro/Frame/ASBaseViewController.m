//
//  ASBaseViewController.m
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASNav.h"

@interface ASBaseViewController ()
@property (strong, nonatomic) UIView *_topView;


@end

@implementation ASBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization

        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_dl"]];

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //topview
    self.topView = [[ASTopView alloc] initWithVc:self];
    self.topView.delegate = self;
    [self.view addSubview:self.topView];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeRightButtonTitle:(NSString *)title{
    NSString *t = [title copy];
    [self.topView.btnRight setTitle:t forState:UIControlStateNormal];
}

- (void)changeTitle:(NSString *)title{
    NSString *t = [title copy];
    [self.topView.lbTitle setText:t];
}

#pragma mark - ASTopViewDelegate
- (void)topViewBackBtnClicked{
    [self navBack];
}

- (void)topViewRightBtnClicked{
    
}

#pragma mark - Nav
/*------------------------------------------------------------------------------
 |  导航
 |
 ------------------------------------------------------------------------------*/
//导航前进
- (void)navTo:(NSString *)key  {
    [self navTo:key params:nil style:NavStyleDefault];
}

- (void)navTo:(NSString *)key params:(NSMutableDictionary *)params style:(NavStyle)style {
    ASBaseViewController *vc = [[ASNav shared] newVcForKey:key];
    
    if(!vc){
        return;
    }

    //页面的key
    vc.pageKey = key;
    
    //导航切换-----------------------
    if (style != NavStyleDefault) {
        if (style!=NavStyleNoEffect) {
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            if (style==NavStyleBottomToTop) {
                transition.duration = 0.4f;
                transition.type = kCATransitionMoveIn;
                transition.subtype = kCATransitionFromTop;
            } else if (style==NavStyleFadeIn) {
                transition.duration = 0.2f;
                transition.type = kCATransitionFade;
            }
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
        }
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//导航回退
- (void)navBack {
    [self navBackTo:nil params:nil style:NavStyleDefault];
}

- (void)navBackTo:(NSString *)key {
    [self navBackTo:nil params:nil style:NavStyleDefault];
}

- (void)navBackTo:(NSString *)key params:(NSMutableDictionary *)params style:(NavStyle)style {
    //-----
    ASBaseViewController *vc;
    NSArray *vcs = self.navigationController.viewControllers;
    
    if([vcs count] == 1){
        return;
    }
    for (int i = [vcs count] - 2; i >= 0; i--) {
        ASBaseViewController *bc = [vcs objectAtIndex:i];
        if([key length] == 0
           ||[bc.pageKey isEqualToString:key]){
            vc = bc;
            break;
        }
    }
    
    //设置导航返回参数
//    vc._tmpNavBackParams = params;
    
    if (style != NavStyleDefault) {
        if (style!=NavStyleNoEffect) {
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            if (style==NavStyleFadeOut) {
                transition.duration = 0.2f;
                transition.type = kCATransitionFade;
            } else if (style==NavStyleTopToBottom) {
                transition.duration = 0.4f;
                transition.type = kCATransitionReveal;
                transition.subtype = kCATransitionFromBottom;
            }
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
        }
        [self.navigationController popToViewController:vc animated:NO];
    } else {
        [self.navigationController popToViewController:vc animated:YES];
    }
}
@end