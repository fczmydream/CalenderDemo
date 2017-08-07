//
//  CollectionReusableView.m
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "CollectionReusableView.h"

@interface CollectionReusableView ()

@end

@implementation CollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, ItemWidth*7, ItemWidth-15)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_timeLabel];
    
    NSArray *weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for(int i=0;i<7;i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ItemWidth*i, ItemWidth, ItemWidth, ItemWidth)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.text = [weeks objectAtIndex:i];
        [self addSubview:label];
    }
}

@end
