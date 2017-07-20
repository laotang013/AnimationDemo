//
//  CircleView.m
//  AnimaDemo
//
//  Created by Start on 2017/7/20.
//  Copyright © 2017年 het. All rights reserved.
//

#import "CircleView.h"
#define  screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define ProgressLineWidth 8 //圆弧的半径
//角度转换成弧度
#define degressToRaidus(ang) ((M_PI*(ang))/180.0f)
#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface CircleView()

@end
@implementation CircleView
   //思路: 1.通过UIBezierPath 加CAShaperLayer进行绘制  2.设置渐变颜色区域同时设置遮罩
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews
{
    /*
     * 用CAShapeLayer的path配合上UIBezierPath
     * 不用backgroundColor 使用fillColor和strokerColor 前者代表设置这个layer的填充色 
     * 后者代表设置他的边框颜色
     http://blog.csdn.net/lxl_815520/article/details/51135835
     CAShapeLayer 使用strokeEnd strokeStart lineWidth
     */
    
    //计算圆弧的半径 圆弧的半长 减去 弧的宽度
    CGFloat radius = (100 - ProgressLineWidth)-5;
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:radius startAngle:degressToRaidus(-225) endAngle:degressToRaidus(45) clockwise:YES];
    circleShape.path = bezierPath.CGPath;
    [self.layer addSublayer:circleShape];
    circleShape.strokeColor = [UIColor redColor].CGColor;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.lineWidth = ProgressLineWidth;
//    circleShape.strokeStart = 0.3;
//    circleShape.strokeEnd = 0.5;
    
    //渐变图层
    //CAGradientLayer类继承自CALayer类是用于在其背景上绘制一个颜色渐变,以填充层的整个形状。CAGradientLayer可以用作PNG的遮罩效果 渐变色的作用范围，变化梯度， 颜色变化的作用点都和CAGradientLayer的坐标系统有关。
    //设定好起点和终点，渐变色的方向就会根据起点指向终点的方向来渐变了。
    CALayer *grain = [CALayer layer];
    //设置渐变图层1
    CAGradientLayer *gradienLayer = [CAGradientLayer layer];
    gradienLayer.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
    [gradienLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor],(id)[RGBColor(142,66, 60) CGColor],nil]];
    //locations并不是表示颜色值所在位置,他表示的是颜色在layer坐标系相对位置处要开始进行渐变颜色了。
    [gradienLayer setLocations:@[@0.1,@0.9]];
    [gradienLayer setStartPoint:CGPointMake(0.05, 1)];
    [gradienLayer setEndPoint:CGPointMake(0.9, 0)];
    [grain addSublayer:gradienLayer];
    
    //设置渐变图层2
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(self.bounds.size.width/2-10, 0, self.bounds.size.width/2+10, self.bounds.size.height);
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[RGBColor(142, 66, 60) CGColor],[(id)[UIColor redColor] CGColor],nil]];
    [gradientLayer2 setLocations:@[@0.3,@1]];
    [gradientLayer2 setStartPoint:CGPointMake(0.9, 0.05)];
    [gradientLayer2 setEndPoint:CGPointMake(1, 1)];
    [grain addSublayer:gradientLayer2];
    //设置遮罩
    [grain setMask:circleShape];
    //添加到layer上
    [self.layer addSublayer:grain];
    //设置动画
    CABasicAnimation *pathAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAni.duration = 6;
    pathAni.fromValue = @0.0f;
    pathAni.toValue = @1.0f;
    pathAni.repeatCount = 2;
    circleShape.path = bezierPath.CGPath;
    [circleShape addAnimation:pathAni forKey:@"strokPathAni"];
    
}
@end
