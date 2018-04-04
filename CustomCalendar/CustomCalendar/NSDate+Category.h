//
//  NSDate+Category.h
//  日历Demo
//
//  Created by 罗孟辉 on 2017/5/4.
//  Copyright © 2017年 罗孟辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

/** 第一天是周几 */
+ (NSInteger)firstWeekdayInThisMotnth:(NSDate *)date;
/** 这个月的天数 */
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
/** 日历的上一个月 */
+ (NSDate *)lastMonth:(NSDate *)date;
/** 日历的下一个月 */
+ (NSDate *)nextMonth:(NSDate *)date;
/** 获取日历的年份 */
+ (NSInteger)year:(NSDate *)date;
/** 获取日历的月份 */
+ (NSInteger)month:(NSDate *)date;
/** 获取日历的为第几天 */
+ (NSInteger)day:(NSDate *)date;


@end
