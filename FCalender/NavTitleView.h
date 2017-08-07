//
//  NavTitleView.h
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavTitleViewDelegate <NSObject>

@optional

- (void)navTitleViewDidSelected:(NSInteger)index;

@end

@interface NavTitleView : UIView

@property (nonatomic,weak) id<NavTitleViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame options:(NSArray *)options selectIndex:(NSInteger)index;

@end
