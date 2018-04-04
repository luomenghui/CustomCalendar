//
//  ViewController.m
//  CustomCalendar
//
//  Created by 罗孟辉 on 2017/8/31.
//  Copyright © 2017年 罗孟辉. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@property (nonatomic, strong) CalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    [self addView];
}

- (void)addView
{
    _calendarView = [[CalendarView alloc] initWithFrame:self.view.bounds];
    _calendarView.isOnlyOneMonth = YES;
    [_calendarView setNeedsDisplay];
    [self.view addSubview:_calendarView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
