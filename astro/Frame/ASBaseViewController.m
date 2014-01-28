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
@property (nonatomic, strong) ASWaitingView *_wtView;
@end

@implementation ASBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_dl"]];
        
        self._wtView = [[ASWaitingView alloc] initWithBaseViewController:self];
        self._wtView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.contentView.contentSize = self.contentView.size;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BaseAlert
- (void)alert:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - ASTopViewDelegate
- (void)topViewBackBtnClicked{
    [self navBack];
}

- (void)topViewRightBtnClicked{
    
}

#pragma mark - Wating Method

- (void)showWaiting{
    [self showWaitingTitle:nil];
}

- (void)showWaitingTitle:(NSString *)title{
    [self._wtView showWating:title];
}

- (void)hideWaiting{
    [self._wtView hideWaiting];
}

- (void)didShowWaiting{
}

- (void)didHideWaiting{
    
}

#pragma mark - ASWaitingView Delegate Method
- (void)asWaitingViewDidHide:(ASWaitingView *)wv{
    [self didHideWaiting];
}

- (void)asWaitingViewDidShow:(ASWaitingView *)wv{
    [self didShowWaiting];
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

#pragma mark - Model Load Delegate
- (void)modelBeginLoad:(ASObject *)sender{
}

- (void)modelLoadFinished:(ASObject *)sender{
}

- (void)modelLoadFaild:(ASObject *)sender message:(NSString *)msg{
}

@end