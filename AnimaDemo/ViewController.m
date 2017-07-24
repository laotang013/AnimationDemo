//
//  ViewController.m
//  AnimaDemo
//
//  Created by Start on 2017/7/20.
//  Copyright © 2017年 het. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用"mas_"前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#define  screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "CircleView.h"
#import "Animation.h"
#import "TotalView.h"
#import <Masonry/Masonry.h>

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
#pragma mark - **************** 动画实现
/**backGroundImageView*/
@property(nonatomic,strong)UIImageView *backgroundImageView;
/**UILabel*/
@property(nonatomic,strong)UILabel *titleLabel;
/**UITableView*/
@property(nonatomic,strong)UITableView *tablView;

//属性
/**约束
 Masonry约束是无法更新 NSLayoutConstraint 约束。因为Masonry在更新约束的时候会去遍历查找view上面的约束集，先判断view上的约束的类是否为 MASLayoutConstraint的类，如果是才会进行更新。所以，如果你是用XIB、StoryBoard拉线添加的约束或者是通过代码方式使用NSLayoutConstraint类添加的约束都无法在代码里用Masonry的 mas_updateConstraints 方法进行约束更新
 */


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self.view addSubview:self.circleView];
    //添加动画界面
    //[self.view addSubview:self.animationView];
    
   //添加一个按钮 1.点击的时候让其旋转 2.弹出遮盖层
    //[self.view addSubview:self.addBtn];
    //[self.view addSubview:self.musicBtn];
#pragma mark - **************** 动画实现
    /*
     1.导航栏的标题实现渐隐
     2.导航栏标题上移
     3.红色背景实现上移隐藏
     4. 文字上移导航栏标题
     */
    self.navigationController.navigationBar.barTintColor = [[UIColor blueColor]colorWithAlphaComponent:0.4];
//    self.navigationItem.title = @"颜色标题";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"颜色标题";
    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    self.navigationItem.titleView = self.titleLabel;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.navigationBar);
    }];
 
    self.backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_background"]];
    [self.view addSubview:self.backgroundImageView];
  
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(72);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.mas_equalTo(45);
        
    }];
    
    
    self.tablView = [[UITableView alloc]init];
    self.tablView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.tablView];
    [self.tablView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom).offset(9);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view insertSubview:self.totalView aboveSubview:self.navigationController.navigationBar];
    [self.totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(72);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.mas_equalTo(45);
    }];
    [self.totalView.muchLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView);
        make.left.right.equalTo(self.totalView).offset(8);
        make.height.equalTo(self.totalView);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.tablView addObserver: self forKeyPath: @"contentOffset" options: NSKeyValueObservingOptionNew context: nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.tablView removeObserver: self forKeyPath: @"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - **************** 监听代理方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGFloat yOffset = self.tablView.contentOffset.y / 64;
    yOffset = MAX(0, MIN(1, yOffset));
    NSLog(@"yOffset: %f",yOffset);
    self.titleLabel.alpha = 1 - yOffset;
     NSLog(@"之前: %f",self.tablView.contentOffset.y); 
    
    [self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(72 - yOffset *64);
        NSLog(@"9 - yOffset *64: %f",72 - yOffset *64);
    }];
    
    NSLog(@"之后: %f",self.tablView.contentOffset.y);
//    [self.totalView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(72 - yOffset *64);
//    }];
   
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
        _totalView = [[TotalView alloc]initWithFrame:self.view.bounds];
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
