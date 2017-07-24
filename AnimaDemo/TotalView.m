//
//  TotalView.m
//  AnimaDemo
//
//  Created by Start on 2017/7/21.
//  Copyright © 2017年 het. All rights reserved.
//

#import "TotalView.h"
#import <Masonry/Masonry.h>
@interface TotalView()

@end
@implementation TotalView
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
    self.muchLabel = [[UILabel alloc]init];
    self.muchLabel.textAlignment = NSTextAlignmentCenter;
    self.muchLabel.text = @"修改";
    self.muchLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.muchLabel];
}
@end
