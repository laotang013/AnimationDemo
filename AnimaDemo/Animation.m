//
//  Animation.m
//  AnimaDemo
//
//  Created by Start on 2017/7/20.
//  Copyright © 2017年 het. All rights reserved.
//

#import "Animation.h"
@interface Animation()
/**动画的View*/
@property(nonatomic,strong)UIView *proPathView;
/**位移*/
@property(nonatomic,strong)UIButton *displacementBtn;
@end
@implementation Animation
/*
 * 动画 简介
     http://blog.csdn.net/yixiangboy/article/details/47016829
    Core Animation是iOS和OSX平台上负责图形渲染与动画的基础框架。CoreAnimation 可以作用于动画视图或者其他
   可视元素，为你完成动画所需的大部分绘针工作。只需要设置开始点的位置和结束点的位置。
 CAAnimation 分为 CAAnimationGroup组动画 CAPropertyAnimation属性动画 以及转场动画CATransition
 常用属性: 
      path: 关键帧动画的执行路径。
      type:过渡动画的动画类型。
      subType:过渡动画的动画方向。
   基础动画：
     重要属性: fromValue keyPath对应的初始值
              toValue keyPath对应的结束值。
    主要提供了对于CALayer对象中的可变属性进行简单动画的操作。
 */
#pragma mark - **************** 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews
{
    [self addSubview:self.proPathView];
    self.proPathView.frame = CGRectMake(50, 100, 80, 80);
    //添加位移按钮
    [self addSubview:self.displacementBtn];
//    self.displacementBtn.frame = cgrectmake
}

#pragma mark - **************** 懒加载
-(UIView *)proPathView
{
    if (!_proPathView) {
        _proPathView = [[UIView alloc]init];
        _proPathView.backgroundColor = [UIColor orangeColor];
    }
    return _proPathView;
}
//位移
-(UIButton *)displacementBtn
{
    if (!_displacementBtn) {
        _displacementBtn = [[UIButton alloc]init];
        [_displacementBtn setTitle:@"位移" forState:UIControlStateNormal];
        [_displacementBtn setBackgroundColor:[UIColor grayColor]];
        _displacementBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _displacementBtn;
}
@end
