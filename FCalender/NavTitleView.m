//
//  NavTitleView.m
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#define TagBegin 200
#define LargeValue 1.15

#import "NavTitleView.h"

@interface NavTitleView () <CAAnimationDelegate>

@property (strong,nonatomic) UIView *selectView;
@property (strong,nonatomic) NSArray *options;
@property (assign,nonatomic) NSInteger selectIndex;
@property (assign,nonatomic) NSInteger animations;

@end

@implementation NavTitleView

- (id)initWithFrame:(CGRect)frame options:(NSArray *)options selectIndex:(NSInteger)index
{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
        
        _options = options;
        _selectIndex = index;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    CGFloat circleWidth = 5.0f;
    NSInteger count = _options.count;
    if(count > 0){
        _selectView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-circleWidth)/2, self.frame.size.height-circleWidth-2, circleWidth, circleWidth)];
        _selectView.backgroundColor = COLOR(189, 1);
        _selectView.layer.masksToBounds = YES;
        _selectView.layer.cornerRadius = circleWidth / 2;
        [_selectView setHidden:YES];
        [self addSubview:_selectView];
    }
    
    CGFloat itemWidth = 60.0f;
    CGFloat itemHeight = 37.0f;
    for(int i=0;i<count;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth*i, 3.5, itemWidth, itemHeight);
        [button setTitle:_options[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR(105, 1) forState:UIControlStateNormal];
        [button setTitleColor:RGBA(49, 114, 167, 1) forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        button.tag = TagBegin + i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if(_selectIndex == i){
            button.selected = YES;
            [self addAnimation:button fromValue:1.0 toValue:LargeValue];
            [_selectView setHidden:NO];
            CGRect rect = _selectView.frame;
            rect.origin.x = itemWidth*i+(itemWidth-circleWidth)/2;
            [_selectView setFrame:rect];
        }else{
            button.selected = NO;
        }
    }
}

- (void)selectAction:(UIButton *)button
{
    NSInteger actionTag = button.tag - TagBegin;
    if(actionTag == _selectIndex) return;
    [self removeAnimation];
    
    UIButton *lastSelectedButton = [self viewWithTag:_selectIndex+TagBegin];
    if(lastSelectedButton){
        lastSelectedButton.selected = NO;
        [self addAnimation:lastSelectedButton fromValue:LargeValue toValue:1.0];
    }
    
    button.selected = YES;
    [self addAnimation:button fromValue:1.0 toValue:LargeValue];
    if(_selectView.hidden) _selectView.hidden = NO;
    CGRect rect = _selectView.frame;
    rect.origin.x = button.frame.origin.x+(button.frame.size.width-_selectView.frame.size.width)/2;
    [_selectView setFrame:rect];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(navTitleViewDidSelected:)]){
        [self.delegate navTitleViewDidSelected:actionTag];
    }
    _selectIndex = actionTag;
}

- (void)addAnimation:(UIButton *)button fromValue:(CGFloat)f toValue:(CGFloat)t
{
    CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    aniScale.fromValue = [NSNumber numberWithFloat:f];
    aniScale.toValue = [NSNumber numberWithFloat:t];
    aniScale.duration = 0.25;
    aniScale.delegate = self;
    aniScale.autoreverses = NO;
    aniScale.removedOnCompletion = NO;
    aniScale.fillMode = kCAFillModeForwards;
    [button.layer addAnimation:aniScale forKey:@"animation"];
    button.transform = CGAffineTransformMakeScale(t, t);
    _animations++;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag) _animations--;
    if(_animations == 0) [self removeAnimation];
}

- (void)removeAnimation
{
    _animations = 0;
    NSInteger count = _options.count;
    for(int i=0;i<count;i++){
        NSInteger btnTag = TagBegin + i;
        UIButton *button = [self viewWithTag:btnTag];
        [button.layer removeAllAnimations];
    }
}

- (void)dealloc
{
    NSLog(@"NavTitleView dealloc...");
}


@end
