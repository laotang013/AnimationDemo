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
 CALayer的设计主要是为了内容展示和动画操作，CALayer本身并不包含在UIKit中,他不能响应事件.
 http://www.cnblogs.com/kenshincui/p/3972100.html
 CALayer中很少使用frame属性,因为frame本省不支持动画效果。通常使用bounds和position代替。
 透明度用opacity表示中心点用position而不是用center表示。anchorPoint属性是图层的锚点这个点永远和
 position中心点重合。当图层中心点固定后，调整anchorPoint即可达到调整图层显示位置的作用（因为它永远和position重合）
 常用属性:
      path: 关键帧动画的执行路径。
      type:过渡动画的动画类型。
      subType:过渡动画的动画方向。
   基础动画：
     重要属性: fromValue keyPath对应的初始值
              toValue keyPath对应的结束值。
    主要提供了对于CALayer对象中的可变属性进行简单动画的操作。
    keyTimes:可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0 keyTimes中的每一个时间值都对应values中
    的每一帧当keyTimes没有设置的时候,各个关键帧的时间是平分。
    组动画:CAAnimation的子类,可以保存一组动画对象，将CAAnimationGroup对象加入层后，组中所有对象可以同时并发运行。
         animations:用来保存一组动画对象的NSArray.
         CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
         groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
         groupAnimation.duration = 4.0f;
 
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
  Cell 高度问题: 
 
  UIScrollView自动布局:
      给UIScrollView添加约束定义其frame,设置contentSize是定义其内部大小UIScrollView进行addSubView操作,都是将其子视图添加到contentView上。添加到UIScrollView上的子视图，对UIScrollView添加的约束都是作用于contentView上的。只需要按照这样的思路给UIScrollView设置约束，就可以掌握设置约束的技巧了。
 
自动contentSize:主要是依赖于创建一个containerView内容视图，并添加到UIScrollView上作为子视图。UIScrollView原来的子视图都添加到containerView上，并且和这个视图设置约束。
 
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
    //self.proPathView.frame = CGRectMake(50, 100, 80, 80);
    [self addSubview:self.bottomView];
    
    [self.proPathView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(100);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 150));
    }];
    
    NSArray *array = @[[UIColor redColor],[UIColor blueColor],[UIColor greenColor]];
    NSMutableArray *arrayView = [NSMutableArray array];
    for(int i=0;i<3;i++)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = array[i];
        [self addSubview:view];
        [arrayView addObject:view];
    }
    
    CGFloat padding = 20;
    UIView *view = arrayView[0];
    UIView *view1 = arrayView[1];
    UIView *view2 = arrayView[2];
    /*
     * 思考: 1.主要是根据x,y以及宽度和高度 2.等宽的话需要确定高度 3.确定间距让其去拉伸确定宽度
     * http://www.jianshu.com/p/8d346d155c12
     */
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.equalTo(self).offset(padding);
        make.right.equalTo(view1.mas_left).offset(-padding);
        make.height.mas_equalTo(30);
    }];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.equalTo(view.mas_right).offset(padding);
        make.width.equalTo(view);
        make.height.equalTo(view);
    }];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.equalTo(view1.mas_right).offset(padding);
        make.right.equalTo(self).offset(-padding);
        make.height.equalTo(view);
        make.width.equalTo(view);
        
    }];
    
    
   
    
    
    
    
    
    
    //更新约束
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//       //更新约束
//       /*
//        - (void)updateConstraintsIfNeeded  调用此方法，如果有标记为需要重新布局的约束，则立即进行重新布局，内部会调用updateConstraints方法
//        - (void)updateConstraints          重写此方法，内部实现自定义布局过程
//        - (BOOL)needsUpdateConstraints     当前是否需要重新布局，内部会判断当前有没有被标记的约束
//        - (void)setNeedsUpdateConstraints  标记需要进行重新布局
//        */
//       [UIView animateWithDuration:2 animations:^{
//           [self.proPathView mas_updateConstraints:^(MASConstraintMaker *make) {
//               make.size.mas_equalTo(CGSizeMake(100, 100));
//           }];
//       }];
//    });
    

    
    
    NSArray *btnArray = @[@"位移",@"透明度",@"缩放",@"旋转",@"背景色"];
    for(int i=0;i<btnArray.count;i++)
    {
        //1.传入数组定义数据 2.创建按钮 2.1 标题和frame
        [self addBtn:i title:btnArray[i]];
    }
    
    //[self setupUI3];
  
}



// 搭建UI 多个视图的布局
- (void) setupUI3
{
    __weak typeof(self) weakSelf = self;
    CGFloat padding = 10.0f;
    UIView * superView = UIView.new;
    [self addSubview:superView];
    superView.backgroundColor = [UIColor redColor];
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(padding+64.0f, padding, padding, padding));
    }];
    
    
    NSInteger count = 3;
    UIView * tempView = nil;
    CGFloat height = 50.0f; // 高度固定等于50
    for (NSInteger i = 0; i<count; i++) {
        
        UIView * subView = UIView.new;
        [superView addSubview:subView];
        subView.backgroundColor = [UIColor brownColor];
        if (i == 0) {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView).offset(padding);
                make.height.equalTo(@(height));
                make.centerY.equalTo(superView);
            }];
            
        } else if (i == count -1) {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(padding);
                make.right.equalTo(superView.mas_right).offset(-padding);
                make.height.equalTo(tempView);
                make.width.equalTo(tempView);
                make.centerY.equalTo(tempView);
            }];
            
        } else {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(padding);
                make.centerY.equalTo(tempView);
                make.height.equalTo(tempView);
                make.width.equalTo(tempView);
                
            }];
            
        }
        
        tempView = subView;
        //[subView layoutIfNeeded];
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
        case 4:
            [self keyWithValues];
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
    //1.初始化动画并设置动画属性 2.设置动画属性的初始值结束值 3.给图层添加动画。
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

//关键帧
-(void)keyWithValues
{
    /*
     * 1.通过设置不同的属性值进行关键帧控制
     * 2.通过绘制路径进行关键帧控制。优先级高于1 如果设置了路径则属性值就不起作用。关键帧动画初始值不能省略。对于路径类型的关键帧动画系统是从描绘路径的位置开始路径直到路径结束。
     
     */
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    NSValue *value = [NSValue valueWithCGPoint:CGPointMake(150, 100)];
//    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(150, 200)];
//    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(50, 200)];
//    anima.values = [NSArray arrayWithObjects:value,value1,value2, nil];
    anima.duration = 2.0f;
    
    //设置路径
    CGPathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.proPathView.layer.position.x, self.proPathView.layer.position.y);//移动到起始点的位置。
    //绘制二次贝塞尔曲线
    CGPathAddCurveToPoint(path, NULL, 160, 280, -30, 300, 55, 400);
    anima.path = path;
    
    
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //anima.beginTime = CACurrentMediaTime() + 2; //设置延迟2秒执行。
    anima.delegate = self;
    [self.proPathView.layer addAnimation:anima forKey:@"keyPath"];
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
