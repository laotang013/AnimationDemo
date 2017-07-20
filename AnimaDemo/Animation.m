//
//  Animation.m
//  AnimaDemo
//
//  Created by Start on 2017/7/20.
//  Copyright © 2017年 het. All rights reserved.
//

#import "Animation.h"
#import <Masonry/Masonry.h>
// 定义这个常量，就可以不用在开发过程中使用"mas_"前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS

@interface Animation()<CAAnimationDelegate>
/**动画的View*/
@property(nonatomic,strong)UIView *proPathView;
/**位移*/
@property(nonatomic,strong)UIButton *displacementBtn;
/**底部View*/
@property(nonatomic,strong)UIView *bottomView;
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

/*
 * Masonry 
    http://www.cocoachina.com/ios/20170109/18538.html
     mas_makeConstraints()    添加约束
     mas_remakeConstraints()  移除之前的约束，重新添加新的约束
     mas_updateConstraints()  更新约束
     
     equalTo()       参数是对象类型，一般是视图对象或者mas_width这样的坐标系对象
     mas_equalTo()   和上面功能相同，参数可以传递基础数据类型对象，可以理解为比上面的API更强大
     
     width()         用来表示宽度，例如代表view的宽度
     mas_width()     用来获取宽度的值。和上面的区别在于，一个代表某个坐标系对象，一个用来获取坐标系对象的值
    所以直接通过点语法就可以调用，还添加了and和with两个方法。这两个方法内部实际上什么都没干，只是在内部将self直接返回，功能就是为了更加方便阅读，对代码执行没有实际作用。
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
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 150));
    }];
    NSArray *btnArray = @[@"位移",@"透明度",@"缩放",@"旋转",@"背景色"];
    for(int i=0;i<btnArray.count;i++)
    {
        //1.传入数组定义数据 2.创建按钮 2.1 标题和frame
        [self addBtn:i title:btnArray[i]];
    }
  
}
#pragma mark - **************** 按钮点击方法
-(void)displacementBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            [self displacement];
            break;
        }
        case 1:
        {
            [self opacityAniamtion];
            break;
        }
        case 2:
        {
            [self scalAnimation];
            break;
        }
        case 3: //帧动画
            [self keyAnima];
            break;
        default:
            break;
    }
    

}
//位移
-(void)displacement
{
    //1.定义动画 2.给谁做动画 3.添加动画
    CABasicAnimation *basiAni = [CABasicAnimation animationWithKeyPath:@"position.x"];
    basiAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 100)];
    basiAni.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
    basiAni.duration = 1.0f;
    //动画执行完毕后 动画保持执行后的状态。图层的属性值还是动画执行前的初始值，并没有真正被改变
    basiAni.fillMode = kCAFillModeForwards;
    basiAni.removedOnCompletion = NO;
    [self.proPathView.layer addAnimation:basiAni forKey:@"positionKey"];
}

//透明度
-(void)opacityAniamtion
{
    //主要是设置keyPath 2. 设置fromValue和toValue
    CABasicAnimation *basiai = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basiai.fromValue = @0.2f;
    basiai.toValue = @1.0f;
    basiai.duration = 3.0f;
    [self.proPathView.layer addAnimation:basiai forKey:@"opacityKey"];
}
-(void)scalAnimation
{
    CABasicAnimation *basiAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basiAni.fromValue = @0.2f;
    basiAni.toValue = @2.0f;
    basiAni.duration = 1.0f;
    [self.proPathView.layer addAnimation:basiAni forKey:@"scaleKey"];
}

//关键帧动画
-(void)keyAnima
{
    //1.设置values 2.设置代理可以检测动画的开始和结束
    CAKeyframeAnimation *keyAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //设置代理可以监听动画的开始和结束。
    keyAni.delegate =self;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 100)];
    keyAni.path = path.CGPath;
    keyAni.duration = 2.0f;
    [self.proPathView.layer addAnimation:keyAni forKey:@"pathKey"];
    
}

-(void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"动画开始");
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画结束");
}



#pragma mark - **************** 创建按钮
-(void)addBtn:(NSInteger)index title:(NSString *)titleStr
{
    //计算每个按钮的frame 九宫格算法
    //每排4个
    NSInteger num = 4;
    CGFloat margin = 30;
    CGFloat btnWidth = ([UIScreen mainScreen].bounds.size.width - 5*margin) / 4;
    CGFloat btnHeight = 30;
    CGFloat btnX = margin + (index%num) *(btnWidth + margin);
    CGFloat btnY = margin + (index/num) *(btnHeight + margin);
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
    [btn setTitle:titleStr forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(displacementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [self.bottomView addSubview:btn];
    
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

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}
@end
