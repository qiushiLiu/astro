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
@property (nonatomic, strong) ASWaitingView *watingView;
@end

@implementation ASBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_dl"]];
        self.watingView = [[ASWaitingView alloc] initWithBaseViewController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //左侧按钮
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 54, 28) title:nil];
    [btn setImage:[UIImage imageNamed:@"icon_navback"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //内容页面
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    self.contentView.contentSize = self.contentView.size;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    CGFloat cH = self.view.height;
    self.contentView.height = cH;
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

#pragma mark - NavBackButton
- (BOOL)viewControllerShouldNavBack{
    return YES;
}

- (void)btnClick_navBack:(UIButton *)sender{
    if([self viewControllerShouldNavBack]){
        [self navBack];
    }
}

#pragma mark - Wating Method

- (void)showWaiting{
    [self showWaitingTitle:nil];
}

- (void)showWaitingTitle:(NSString *)title{
    [self.watingView showWating:title];
}

- (void)hideWaiting{
    [self.watingView hideWaiting];
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
- (void)setNavToParams:(NSMutableDictionary *)params{
    
}

- (void)setNavBackParams:(NSMutableDictionary *)params{
    
}

//导航前进
- (ASBaseViewController *)navTo:(NSString *)key  {
    return [self navTo:key params:nil];
}

- (ASBaseViewController *)navTo:(NSString *)key params:(NSDictionary *)params{
    ASBaseViewController *vc = [[ASNav shared] newVcForKey:key];
    
    if(!vc){
        return nil;
    }

    //页面的key
    vc.pageKey = key;
    [vc setNavToParams:params];
    [self.navigationController pushViewController:vc animated:YES ];
    return vc;
}

//导航回退
- (ASBaseViewController *)navBack {
    return [self navBackTo:nil thenNavTo:nil];
}

- (ASBaseViewController *)navBackTo:(NSString *)key params:(NSDictionary *)params {
    return [self navBackTo:key thenNavTo:nil params:params];
}

- (ASBaseViewController *)navBackTo:(NSString *)baseKey thenNavTo:(NSString *)key{
    return [self navBackTo:baseKey thenNavTo:key params:nil];
}

- (ASBaseViewController *)navBackTo:(NSString *)baseKey thenNavTo:(NSString *)key params:(NSDictionary *)params{
    ASBaseViewController *vc;
    NSArray *vcs = self.navigationController.viewControllers;
    
    if([vcs count] == 1){
        return nil;
    }
    
    for (NSInteger i = [vcs count] - 2; i >= 0; i--) {
        ASBaseViewController *bc = [vcs objectAtIndex:i];
        if([key length] == 0
           ||[bc.pageKey isEqualToString:key]){
            vc = bc;
            break;
        }
    }
    if([key length] > 0){
        [self.navigationController popToViewController:vc animated:NO];
        return [self navTo:key params:params];
    }else{
        [vc setNavBackParams:params];
        [self.navigationController popToViewController:vc animated:YES];
        return vc;
    }
}

@end