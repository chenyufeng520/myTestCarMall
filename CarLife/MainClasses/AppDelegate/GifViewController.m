//
//  GifViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/13.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GifViewController.h"
#import "AppDelegate.h"

@interface GifViewController ()

@property(nonatomic,strong)UIImageView *animationImageView;

@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self startAnimation];
}

- (void)startAnimation{
    _animationImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_animationImageView];
    NSMutableArray *fireArr = [[NSMutableArray alloc]init];
    for (int i = 1; i < 6; i++)
    {
        NSString *name = [NSString stringWithFormat:@"startAnimation%d.png",i];
        UIImage *fireImg = [UIImage imageNamed:name];
        [fireArr addObject:fireImg];
    }
    _animationImageView.animationDuration = 0.1 * fireArr.count;
    _animationImageView.animationImages = fireArr;
    _animationImageView.animationRepeatCount = 0;
    [_animationImageView startAnimating];
    [self performSelector:@selector(layoutMainView) withObject:nil afterDelay:3];

}

- (void)layoutMainView{
    
    [[AppDelegate shareDelegate] layoutMainView:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
