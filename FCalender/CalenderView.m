//
//  CalenderView.m
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "CalenderView.h"
#import "CalenderTool.h"
#import "CalenderCell.h"
#import "CollectionReusableView.h"
#import "CollectionViewFlowLayout.h"

@interface CalenderView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSString *selectDate;
@property (nonatomic,strong) CalenderTool *tool;
@property (nonatomic,assign) CalenderType typeId;

@end

@implementation CalenderView

- (id)initWithFrame:(CGRect)frame selectDay:(NSString *)selected withType:(CalenderType)typeId
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:RGBA(41, 42, 44, 0.5)];
        self.alpha = 0;
        self.selectDate = selected;
        self.typeId = typeId;
        self.tool = [CalenderTool shared];
        [self createCalenderUI];
    }
    return self;
}

- (void)createCalenderUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    CGFloat collectionX = (SCREEN_WIDTH - ItemWidth * 7) / 2;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionX, 145, ItemWidth*7, ItemWidth*8) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = RGBA(61, 61, 61, 1);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.layer.masksToBounds = YES;
    _collectionView.layer.cornerRadius = 5;
    _collectionView.layer.shadowColor = RGBA(41, 42, 44, 0.7).CGColor;
    _collectionView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    [_collectionView registerClass:[CalenderCell class] forCellWithReuseIdentifier:@"CalenderCell"];
    [_collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView"];
    [self addSubview:_collectionView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)showType:(CalenderType)typeId selectDay:(NSString *)dayString
{
    _typeId = typeId;
    _selectDate = dayString;
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[self indexPathFromString:_selectDate] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapAction
{
    [self dismiss];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (EndYear - StartYear + 1) * 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger year = StartYear + section / 12;
    NSInteger month = section % 12 + 1;
    NSString *string = [NSString stringWithFormat:@"%ld-%02ld-01",year,month];
    return [_tool getMonthWeeks:string] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalenderCell" forIndexPath:indexPath];
    NSInteger year = StartYear + indexPath.section / 12;
    NSInteger month = indexPath.section % 12 + 1;
    NSString *string = [NSString stringWithFormat:@"%ld-%02ld-01",year,month];
    NSInteger monthDays = [_tool getMonthDays:string];
    NSInteger weekSeveral = [_tool getWeekSeveral:string];
    NSInteger cellDay = indexPath.row + 1 - weekSeveral + 1;
    if(cellDay <= 0 || cellDay > monthDays) cellDay = 0;
    NSArray *selects = @[_selectDate];
    if(_typeId == CalenderTypeWeek){
        selects = [_tool getWeekAllDays:_selectDate];
    }else if(_typeId == CalenderTypeMonth){
        selects = [_tool getMonthAllDays:_selectDate];
    }
    NSString *cellString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,cellDay];
    if(selects && [selects containsObject:cellString]){
        [cell setDayNumber:cellDay selected:YES];
    }else{
        [cell setDayNumber:cellDay selected:NO];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ItemWidth, ItemWidth);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ItemWidth*7, ItemWidth*2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        NSInteger year = StartYear + indexPath.section / 12;
        NSInteger month = indexPath.section % 12 + 1;
        reusableView.timeLabel.text = [NSString stringWithFormat:@"%ld年%ld月",year,month];
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if([self stringAtIndexPath:indexPath]){
        _selectDate = [self stringAtIndexPath:indexPath];
        [collectionView reloadData];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(calenderViewDidSelect:type:)]){
            [self.delegate calenderViewDidSelect:_selectDate type:_typeId];
        }
    }
}

- (NSIndexPath *)indexPathFromString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"-"];
    if(array && array.count == 3){
        NSInteger year = [[array objectAtIndex:0] integerValue];
        NSInteger month = [[array objectAtIndex:1] integerValue];
        NSInteger section = (year - StartYear) * 12 + month - 1;
        return [NSIndexPath indexPathForRow:0 inSection:section];
    }else{
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (NSString *)stringAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger year = StartYear + indexPath.section / 12;
    NSInteger month = indexPath.section % 12 + 1;
    NSString *string = [NSString stringWithFormat:@"%ld-%02ld-01",year,month];
    NSInteger monthDays = [_tool getMonthDays:string];
    NSInteger weekSeveral = [_tool getWeekSeveral:string];
    NSInteger cellDay = indexPath.row + 1 - weekSeveral + 1;
    if(cellDay <= 0 || cellDay > monthDays){
        return nil;
    }else{
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,cellDay];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CalenderView"]) {
        return YES;
    }
    return NO;
}


@end
