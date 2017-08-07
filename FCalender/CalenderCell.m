//
//  CalenderCell.m
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "CalenderCell.h"

@interface CalenderCell ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation CalenderCell

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    CGFloat labelX = (ItemWidth - 30) / 2;
    _label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelX, 30, 30)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:13];
    _label.layer.masksToBounds = YES;
    _label.layer.cornerRadius = 15.0f;
    _label.layer.borderWidth = 1.0f;
    _label.layer.borderColor = RGBA(210, 210, 210, 1).CGColor;
    [self.contentView addSubview:_label];
}

- (void)setDayNumber:(NSInteger)number selected:(BOOL)b
{
    if(b) _label.layer.borderColor = RGBA(49, 114, 167, 1).CGColor;
    else _label.layer.borderColor  = RGBA(210, 210, 210, 1).CGColor;
    if(number == 0){
        _label.text = @"";
        _label.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        _label.text = [NSString stringWithFormat:@"%ld",number];
    }
}

@end
