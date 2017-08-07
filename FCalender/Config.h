//
//  Config.h
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#ifndef Config_h
#define Config_h

//尺寸
#define ItemWidth 45
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COLOR(x, a) RGBA(x, x, x, a)

//时间
#define StartYear 2015
#define EndYear 2020


#endif /* Config_h */
