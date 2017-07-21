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
#import "TotalView.h"
@interface ViewController ()
/**添加圆圈*/
@property(nonatomic,strong)CircleView *circleView;
/**动画界面*/
@property(nonatomic,strong)Animation *animationView;
/**Path动画*/
@property(nonatomic,strong)TotalView *totalView;
/**点击弹出视图*/
@property(nonatomic,strong)UIButton *addBtn;
/**音乐按钮*/
@property(nonatomic,strong)UIButton *musicBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self.view addSubview:self.circleView];
    //添加动画界面
    [self.view addSubview:self.animationView];
    
   //添加一个按钮 1.点击的时候让其旋转 2.弹出遮盖层
    //[self.view addSubview:self.addBtn];
    //[self.view addSubview:self.musicBtn];
    
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

-(TotalView *)totalView
{
    if (!_totalView) {
        _totalView = [[TotalView alloc]init];
    }
    return _totalView;
}

-(UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 200, 50, 50)];
        [_addBtn setImage:[UIImage imageNamed:@"chooser-button-tab"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"] forState:UIControlStateHighlighted];
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

-(UIButton *)musicBtn
{
    if (!_musicBtn) {
        _musicBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 200, 50, 50)];
        [_musicBtn setImage:[UIImage imageNamed:@"chooser-moment-icon-music"] forState:UIControlStateNormal];
        [_musicBtn setImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"] forState:UIControlStateHighlighted];
        //[_musicBtn addTarget:self action:@selector(_musicBtn:) forControlEvents:UIControlEventTouchUpInside];
        _musicBtn.hidden = YES;
    }
    return _musicBtn;

}

#pragma mark - **************** 按钮点击
-(void)addBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //旋转动画transform.rotation.z
        [self roatationAddBtn:@(M_PI_4)];
        self.musicBtn.hidden = NO;
        [self groupAnimation];
    }else
    {
        [self roatationAddBtn:@(-M_PI_2)];
        [self groupAnimation1];
    }
}

-(void)roatationAddBtn:(NSValue *)value
{
    //旋转动画transform.rotation.z
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.toValue = value;
    anima.duration = 0.5f;
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    [self.addBtn.layer addAnimation:anima forKey:@"transformKeyPath"];
}

//1.设置一个弧度 让其toValue到这个地方 同时让其旋转  组动画
-(void)groupAnimation
{
    //计算toValue的值
  CGPoint toValuePoint =   CGPointMake(self.musicBtn.frame.origin.x - cosf(30*M_PI)*120,self.musicBtn.frame.origin.y - sinf(30*M_PI)*120);
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.toValue = [NSValue valueWithCGPoint:toValuePoint];
    anima.duration = 1.0f;
   
    
    //旋转
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ani.toValue = @(M_PI*2 * 4);
    ani.duration = 2.0f;
   
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[anima,ani];
    group.duration = 0.5f;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [self.musicBtn.layer addAnimation:group forKey:@"groupKey"];
    
}


-(void)groupAnimation1
{
    //计算toValue的值
    CGPoint toValuePoint =   CGPointMake(self.addBtn.frame.origin.x,self.addBtn.frame.origin.y );
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.toValue = [NSValue valueWithCGPoint:toValuePoint];
    anima.duration = 1.0f;
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    
    //旋转
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ani.toValue = @(M_PI*2 * 4);
    ani.duration = 2.0f;
    ani.fillMode = kCAFillModeForwards;
    ani.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[anima,ani];
    group.duration = 0.5f;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [self.musicBtn.layer addAnimation:group forKey:@"groupKey"];
    
}

@end
