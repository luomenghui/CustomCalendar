//
//  CalendarView.m
//  日历Demo
//
//  Created by 罗孟辉 on 2017/5/4.
//  Copyright © 2017年 罗孟辉. All rights reserved.
//

#import "CalendarView.h"
#import "NSDate+Category.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define scaleWidth [UIScreen mainScreen].bounds.size.width / 375.0
#define scaleHeight [UIScreen mainScreen].bounds.size.height / 667.0

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define itemW SCREENWIDTH / 7
#define itemH 39 * scaleHeight

@interface CalendarView ()

@property (nonatomic, strong) UILabel *selectDateLabel;
@property (nonatomic, strong) UIView *calBackView;
@property (nonatomic, assign) NSInteger selectIndex;    // 被选中的日期在42个方格中的位置，0 - 41，初始值99
@property (nonatomic, strong) NSDate *todayDate;        // 今日日期
@property (nonatomic, strong) NSDate *changeDate;       // 点击下一月或上一月改变后的时间，点击改变天数，该值不改变

@end

@implementation CalendarView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        _todayDate = [NSDate date];
        _selectIndex = 99;
        
        UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 25 * scaleHeight, SCREENWIDTH, 50 * scaleHeight)];
        headBackView.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:headBackView];
        
        NSInteger year = [NSDate year:_todayDate];
        NSInteger month = [NSDate month:_todayDate];
        _selectDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 50, 15 * scaleHeight, 100, 20 * scaleHeight)];
        _selectDateLabel.text = [NSString stringWithFormat:@"%ld年%ld月", year, month];
        [headBackView addSubview:_selectDateLabel];
        
        UIButton *lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lastMonthBtn.tag = 0;
        lastMonthBtn.layer.cornerRadius = 5;
        lastMonthBtn.layer.masksToBounds = YES;
        [lastMonthBtn setTitle:@"上一月" forState:UIControlStateNormal];
        [lastMonthBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        lastMonthBtn.frame = CGRectMake(18 * scaleWidth, 10 * scaleHeight, 70, 30 * scaleHeight);
        [lastMonthBtn addTarget:self action:@selector(changeTheMonth:) forControlEvents:UIControlEventTouchUpInside];
        [headBackView addSubview:lastMonthBtn];
        
        UIButton *nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextMonthBtn.tag = 1;
        nextMonthBtn.layer.cornerRadius = 5;
        nextMonthBtn.layer.masksToBounds = YES;
        [nextMonthBtn setTitle:@"下一月" forState:UIControlStateNormal];
        [nextMonthBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        nextMonthBtn.frame = CGRectMake(SCREENWIDTH - 18 * scaleWidth - 70, 10 * scaleHeight, 70, 30 * scaleHeight);
        [nextMonthBtn addTarget:self action:@selector(changeTheMonth:) forControlEvents:UIControlEventTouchUpInside];
        [headBackView addSubview:nextMonthBtn];
        
        UIView *weekBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 75 * scaleHeight, SCREENWIDTH, 40 * scaleHeight)];
        weekBackView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:weekBackView];
        
        NSArray *texts = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        for (int i = 0; i < 7; ++i)
        {
            CGFloat width = SCREENWIDTH / 7;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * i, 10 * scaleHeight, width, 20 * scaleHeight)];
            label.text = texts[i];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = UIColorFromRGB(0x000000);
            label.textAlignment = NSTextAlignmentCenter;
            [weekBackView addSubview:label];
        }
        
        _changeDate = _todayDate;
        _selcetDate = _todayDate;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [_calBackView removeFromSuperview];

    _calBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 115 * scaleHeight, SCREENWIDTH, 258 * scaleHeight)];
    _calBackView.backgroundColor = UIColorFromRGB(0xffffff);
    [self addSubview:_calBackView];
    
    // 1.分析这个月的第一天是第一周的星期几
    NSInteger firstWeekday = [NSDate firstWeekdayInThisMotnth:_changeDate];
    
    // 2.分析这个月有多少天
    NSInteger dayInThisMonth = [NSDate totaldaysInMonth:_changeDate];
    
    // 3.分析上一个月有多少天
    NSInteger dayInLastMonth = [NSDate totaldaysInMonth:[NSDate lastMonth:_changeDate]];
    
    // 4.今天是本月的第几天
    NSInteger today = [NSDate day:_changeDate];
    
    // 创建日历
    for (int i = 0; i < 42; i ++)
    {
        if (_isOnlyOneMonth)
        {
            if (i < firstWeekday || i > firstWeekday + dayInThisMonth - 1)
            {
                continue;
            }
        }
        
        int x = (i % 7) * itemW;
        int y = (i / 7) * itemH + 12 * scaleHeight;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(x, y, itemW, itemH)];
        backView.backgroundColor = [UIColor clearColor];
        [_calBackView addSubview:backView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        button.frame = CGRectMake(backView.frame.size.width / 2 - 15 * scaleWidth, backView.frame.size.height / 2 - 15 * scaleWidth, 30 * scaleWidth, 30 * scaleWidth);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.masksToBounds = YES;
        button.tag = i;
        [backView addSubview:button];
        
        // 给显示的每一天添加点击事件
        [button addTarget:self action:@selector(clickTheDay:) forControlEvents:UIControlEventTouchUpInside];
        if (i < firstWeekday || i > firstWeekday + dayInThisMonth - 1)
        {
            [button setTitleColor:UIColorFromRGB(0xfe961d) forState:UIControlStateNormal];
        }
        
        NSInteger day = 0;
        
        if (i < firstWeekday)
        {
            day = dayInLastMonth - firstWeekday + i + 1;
        }
        else if (i > firstWeekday + dayInThisMonth - 1)
        {
            day = i + 1 - firstWeekday - dayInThisMonth;
        }
        else
        {
            day = i - firstWeekday + 1;
        }
        
        [button setTitle:[NSString stringWithFormat:@"%d",(int)day] forState:UIControlStateNormal];
        if (_selectIndex == 99)   // 初始值为99，点击某一天后其值改变
        {
            if (i == firstWeekday + today - 1)  // 选中今天
            {
                button.layer.cornerRadius = 30 * scaleWidth / 2;
                button.selected = YES;
                button.backgroundColor = UIColorFromRGB(0x1faf50);
            }
        }
        else
        {
            if (i == _selectIndex)  // 被点击的那天，设置为选中
            {
                button.layer.cornerRadius = 30 * scaleWidth / 2;
                button.selected = YES;
                button.backgroundColor = UIColorFromRGB(0x1faf50);
            }
        }
    }
    // 当 isOnlyOneMonth 的值为 YES 时，调整 calBackView 的 frame
    if (_isOnlyOneMonth)
    {
        NSInteger divisor = (firstWeekday + dayInThisMonth)  / 7;
        NSInteger remainder = (firstWeekday + dayInThisMonth)  % 7;
        if (remainder != 0)
        {
            divisor += 1;
        }
        CGFloat height = divisor * itemH + 24 * scaleHeight;
        _calBackView.frame = CGRectMake(0, 115 * scaleHeight, SCREENWIDTH, height);
    }
}

#pragma mark - 改变月份
- (void)changeTheMonth:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        _changeDate = [NSDate lastMonth:_changeDate];
    }
    else
    {
        _changeDate = [NSDate nextMonth:_changeDate];
    }
    _selcetDate = _changeDate;
    
    NSInteger monthChange = [NSDate month:_changeDate];
    NSInteger monthCurrent = [NSDate month:_todayDate];
    if (monthChange == monthCurrent)   // 本月
    {
        _selectIndex = 99;  // 恢复初始值
        _changeDate = _todayDate;
        _selcetDate = _changeDate;
        NSInteger year = [NSDate year:_selcetDate];
        NSInteger month = [NSDate month:_selcetDate];
        
        _selectDateLabel.text = [NSString stringWithFormat:@"%ld年%ld月", year, month];
    }
    else    // 非本月
    {
        NSInteger year = [NSDate year:_selcetDate];
        NSInteger month = [NSDate month:_selcetDate];
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-01", year, month];
        _changeDate = [self dateFromeStr:dateStr];
        _selcetDate = _changeDate;
        
        // 设置非本月外的每个月初始被选中的日期都是1号
        NSInteger firstWeekday = [NSDate firstWeekdayInThisMotnth:_changeDate];
        _selectIndex = firstWeekday;
        
        _selectDateLabel.text = [NSString stringWithFormat:@"%ld年%ld月", year, month];
    }
    
    NSLog(@"改变月份选中的日期: %@", [self strFromDate:_selcetDate]);
    [self setNeedsDisplay];
}

#pragma mark - 点击某一天
- (void)clickTheDay:(UIButton *)button
{
    button.layer.cornerRadius = 30 * scaleWidth / 2;
    button.selected = YES;
    button.backgroundColor = UIColorFromRGB(0x1faf50);
    _selectIndex = button.tag;
    [self getHasChangedDate:button.tag];
    NSLog(@"改变天数选中的日期: %@", [self strFromDate:_selcetDate]);
    [self setNeedsDisplay];
}

#pragma mark - 点击某一天后获取选中的日期
- (void)getHasChangedDate:(NSInteger)tag
{
    NSInteger monthChange = [NSDate month:_changeDate];
    NSInteger monthSelect = [NSDate month:_selcetDate];
    
    if (monthSelect == monthChange)     // 选中日期月份与当前月相同
    {
        NSInteger firstWeekday = [NSDate firstWeekdayInThisMotnth:_selcetDate];
        NSInteger dayInThisMonth = [NSDate totaldaysInMonth:_selcetDate];
        NSInteger today = [NSDate day:_selcetDate];
        NSInteger todayTag = firstWeekday +today - 1;
        
        NSInteger year = [NSDate year:_selcetDate];
        NSInteger month = [NSDate month:_selcetDate];
        NSInteger day = [NSDate day:_selcetDate];
        
        NSInteger newDay = day + tag - todayTag;
        
        if (newDay <= 0)
        {
            _selcetDate = [NSDate lastMonth:_selcetDate];
            NSInteger dayInLastMonth = [NSDate totaldaysInMonth:_selcetDate];
            year = [NSDate year:_selcetDate];
            month = [NSDate month:_selcetDate];
            newDay += dayInLastMonth;
        }
        else if (newDay > dayInThisMonth)
        {
            _selcetDate = [NSDate nextMonth:_selcetDate];
            year = [NSDate year:_selcetDate];
            month = [NSDate month:_selcetDate];
            newDay -= dayInThisMonth;
        }
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, newDay];
        NSDate *date = [self dateFromeStr:dateStr];
        _selcetDate = date;
    }
    else if (monthSelect < monthChange)     // 选中日期月份是当前月的前一月
    {
        NSInteger firstWeekday = [NSDate firstWeekdayInThisMotnth:_changeDate];
        NSInteger dayInThisMonth = [NSDate totaldaysInMonth:_changeDate];
        NSInteger dayInLastMonth = [NSDate totaldaysInMonth:_selcetDate];
        NSInteger today = [NSDate day:_selcetDate];
        NSInteger todayTag = firstWeekday -(dayInLastMonth - today) - 1;
        
        NSInteger year = [NSDate year:_selcetDate];
        NSInteger month = [NSDate month:_selcetDate];
        NSInteger day = [NSDate day:_selcetDate];
        
        NSInteger newDay = day + tag - todayTag;
        
        if (newDay > dayInLastMonth && newDay <= dayInLastMonth + dayInThisMonth)
        {
            year = [NSDate year:_changeDate];
            month = [NSDate month:_changeDate];
            newDay = newDay - dayInLastMonth;
        }
        if (newDay > dayInLastMonth + dayInThisMonth)
        {
            year = [NSDate year:[NSDate nextMonth:_changeDate]];
            month = [NSDate month:[NSDate nextMonth:_changeDate]];
            newDay = newDay - dayInLastMonth -dayInThisMonth;
        }
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, newDay];
        NSDate *date = [self dateFromeStr:dateStr];
        _selcetDate = date;
    }
    else    // 选中日期月份是当前月的后一月
    {
        NSInteger firstWeekday = [NSDate firstWeekdayInThisMotnth:_changeDate];
        NSInteger dayInThisMonth = [NSDate totaldaysInMonth:_changeDate];
        NSInteger dayInLastMonth = [NSDate totaldaysInMonth:_selcetDate];
        NSInteger today = [NSDate day:_selcetDate];
        NSInteger todayTag = firstWeekday + dayInThisMonth + today - 1;
        
        NSInteger year = [NSDate year:_selcetDate];
        NSInteger month = [NSDate month:_selcetDate];
        NSInteger day = [NSDate day:_selcetDate];
        
        NSInteger newDay = day + tag - todayTag;

        if (newDay > 0)
        {
            // 重新选中日期月份仍是当前月的后一月
        }
        else if (newDay + dayInThisMonth > 0)   // 重新选中日期月份是当前月
        {
            year = [NSDate year:_changeDate];
            month = [NSDate month:_changeDate];
            newDay = newDay + dayInThisMonth;
        }
        else    // 重新选中日期月份是当前月的上一月
        {
            year = [NSDate year:[NSDate lastMonth:_changeDate]];
            month = [NSDate month:[NSDate lastMonth:_changeDate]];
            newDay = newDay + dayInThisMonth + dayInLastMonth;
        }
        
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, newDay];
        NSDate *date = [self dateFromeStr:dateStr];
        _selcetDate = date;
    }
}

- (NSString *)strFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    
    return str;
}

- (NSDate *)dateFromeStr:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:str];
    
    return date;
}

@end
