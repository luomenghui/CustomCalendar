//
//  NSDate+Category.m
//  日历Demo
//
//  Created by 罗孟辉 on 2017/5/4.
//  Copyright © 2017年 罗孟辉. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

#pragma mark - 第一天是周几
+ (NSInteger)firstWeekdayInThisMotnth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar]; // 取得当前用户的逻辑日历(logical calendar)
    
    [calendar setFirstWeekday:1]; //  设定每周的第一天从星期几开始，比如:. 如需设定从星期日开始，则value传入1 ，如需设定从星期一开始，则value传入2 ，以此类推
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [comp setDay:1]; // 设置为这个月的第一天
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate]; // 这个月第一天在当前日历的顺序
    // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的顺序
    return firstWeekday - 1;
}

#pragma mark - 这个月的天数
+ (NSInteger)totaldaysInMonth:(NSDate *)date
{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]; // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的范围
    
    return daysInOfMonth.length;
}

#pragma mark - 日历的上一个月
+ (NSDate *)lastMonth:(NSDate *)date
{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    return newDate;
}

#pragma mark - 日历的下一个月
+ (NSDate *)nextMonth:(NSDate *)date
{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.month = 1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    return newDate;
}

#pragma mark - 获取日历的年份
+ (NSInteger)year:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

#pragma mark - 获取日历的月份
+ (NSInteger)month:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

#pragma mark - 获取日历的为第几天
+ (NSInteger)day:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

@end
