//
//  CalenderView.h
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

typedef NS_ENUM(NSInteger,CalenderType){
    CalenderTypeDay,
    CalenderTypeWeek,
    CalenderTypeMonth
};

@protocol CalenderViewDelegate <NSObject>

@optional

- (void)calenderViewDidSelect:(NSString *)dateString type:(CalenderType)typeId;

@end


#import <UIKit/UIKit.h>

@interface CalenderView : UIView

@property (nonatomic,weak) id<CalenderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame selectDay:(NSString *)selected withType:(CalenderType)typeId;

- (void)showType:(CalenderType)typeId selectDay:(NSString *)dayString;

- (void)dismiss;

@end
