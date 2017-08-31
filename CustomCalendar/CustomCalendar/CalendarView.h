//
//  CalendarView.h
//  日历Demo
//
//  Created by 罗孟辉 on 2017/5/4.
//  Copyright © 2017年 罗孟辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView


@property (nonatomic, assign) BOOL isOnlyOneMonth;          // 是否只显示本月日期
@property (nonatomic, strong) NSDate *selcetDate;           // 选中的日期

@end
