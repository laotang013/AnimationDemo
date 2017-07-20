//
//  ViewController.m
//  AnimaDemo
//
//  Created by Start on 2017/7/20.
//  Copyright © 2017年 het. All rights reserved.
//
#define  screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "CircleView.h"
#import "Animation.h"
@interface ViewController ()
/**添加圆圈*/
@property(nonatomic,strong)CircleView *circleView;
/**动画界面*/
@property(nonatomic,strong)Animation *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self.view addSubview:self.circleView];
    //添加动画界面
    [self.view addSubview:self.animationView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - **************** 懒加载
-(CircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[CircleView alloc]initWithFrame: CGRectMake(60, 50, 200, 200)];
        _circleView.backgroundColor = [UIColor yellowColor];
    }
    return _circleView;
}
-(Animation *)animationView
{
    if (!_animationView) {
        _animationView = [[Animation alloc]initWithFrame:self.view.bounds];
    }
    return _animationView;
}
@end
