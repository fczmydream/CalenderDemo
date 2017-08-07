//
//  ViewController.m
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "ViewController.h"
#import "CalenderView.h"
#import "CalenderTool.h"
#import "NavTitleView.h"

@interface ViewController () <CalenderViewDelegate,NavTitleViewDelegate>

@property (nonatomic,strong) CalenderView *calenderView;
@property (nonatomic,strong) CalenderTool *tool;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) NSString *selectTime;
@property (nonatomic,assign) NSInteger calenderTypeId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setNavUI];
    
    _calenderTypeId = 0;
    _tool = [CalenderTool shared];
    _selectTime = [_tool stringFromTime:[NSDate date]];
    _calenderView = [[CalenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) selectDay:_selectTime withType:CalenderTypeDay];
    _calenderView.delegate = self;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 79, 150, 45)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.textColor = COLOR(61, 1);
    _timeLabel.text = _selectTime;
    [self.view addSubview:_timeLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(_timeLabel.frame.origin.x-45, _timeLabel.frame.origin.y, 45, 45);
    backButton.tag = 100;
    [backButton setTitle:@"向前" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(_timeLabel.frame.origin.x+_timeLabel.frame.size.width, _timeLabel.frame.origin.y, 45, 45);
    nextButton.tag = 101;
    [nextButton setTitle:@"向后" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)timeAction:(UIButton *)button
{
    BOOL increase = NO;
    if(button.tag == 101) increase = YES;
    
    if(_calenderTypeId == 0){
        _selectTime = [_tool timeAddDay:_selectTime increase:increase];
        _timeLabel.text = _selectTime;
    }else if(_calenderTypeId == 1){
        NSArray *days = [_tool getWeekAllDays:_selectTime];
        _timeLabel.text = [_tool timeAddWeek:days increase:increase];
        _selectTime = [_timeLabel.text substringToIndex:10];
    }else if(_calenderTypeId == 2){
        NSArray *days = [_tool getMonthAllDays:_selectTime];
        _timeLabel.text = [_tool timeAddMonth:days increase:increase];
        _selectTime = [NSString stringWithFormat:@"%@-01",_timeLabel.text];
    }
}

- (void)setNavUI
{
    NavTitleView *titleButton = [[NavTitleView alloc] initWithFrame:CGRectMake(0, 0, 180, 44) options:@[@"日",@"周",@"月"] selectIndex:0];
    titleButton.delegate = self;
    self.navigationItem.titleView = titleButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"日历" style:UIBarButtonItemStylePlain target:self action:@selector(showCalender)];
}

- (void)navTitleViewDidSelected:(NSInteger)index
{
    _calenderTypeId = index;
    if(_calenderTypeId == 0){
        _timeLabel.text = _selectTime;
    }else if(_calenderTypeId == 1){
        NSArray *days = [_tool getWeekAllDays:_selectTime];
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[days firstObject],[days lastObject]];
    }else if(_calenderTypeId == 2){
        _timeLabel.text = [_selectTime substringToIndex:7];
    }
}

- (void)showCalender
{
    [_calenderView showType:_calenderTypeId selectDay:_selectTime];
}

- (void)calenderViewDidSelect:(NSString *)dateString type:(CalenderType)typeId
{
    _selectTime = dateString;
    if(typeId == 0){
        _timeLabel.text = _selectTime;
    }else if(typeId == 1){
        NSArray *days = [_tool getWeekAllDays:_selectTime];
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[days firstObject],[days lastObject]];
    }else if(typeId == 2){
        _timeLabel.text = [_selectTime substringToIndex:7];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
