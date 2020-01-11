//
//  NSDate+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AC_WEEK_IN_DAYS 7
#define AC_SECOND_IN_MILLISECONDS 1000
#define AC_SECONDS_IN_SECONDS   1
#define AC_MINUTE_IN_SECONDS    60
#define AC_HOUR_IN_SECONDS     (60 * 60)
#define AC_DAY_IN_SECONDS      (60 * 60 * 24)
#define AC_WEEK_IN_SECONDS     (60 * 60 * 24 * AC_WEEK_IN_DAYS)

#define AC_UTC_KEY @"UTC"

#define AC_EN_US_POSIX_LOCALE_IDENTIFIER @"en_US_POSIX"

@interface NSDate(AppCore)
+ (NSCalendar *)ac_currentCalendar;
+ (NSInteger)ac_currentTimeZone;

+ (instancetype)ac_dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute;
+ (instancetype)ac_dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

+ (instancetype)ac_date:(NSString *)dateString
             dateFormat:(NSString *)dateFormat
   timeZoneAbbreviation:(NSString *)timeZoneAbbreviation;

+ (instancetype)ac_date:(NSString *)dateString dateFormat:(NSString *)dateFormat;
+ (instancetype)ac_dateUTC:(NSString *)dateString dateFormat:(NSString *)dateFormat;
+ (instancetype)ac_dateWithTimestamp:(NSTimeInterval)timestamp;

- (NSString *)ac_stringWithFormat:(NSString *)format
             timeZoneAbbreviation:(NSString *)timeZoneAbbreviation
                           locale:(NSLocale *)locale;

- (NSString *)ac_stringWithFormat:(NSString *)format
             timeZoneAbbreviation:(NSString *)timeZoneAbbreviation;

- (NSString *)ac_stringWithFormat:(NSString *)format;
- (NSString *)ac_stringUTCWithFormat:(NSString *)format;

- (BOOL)ac_isWeekend;
- (NSDate *)ac_dateByAddingDay:(int)day;
- (NSDate *)ac_nextDay;
- (NSDate *)ac_previousDay;
- (NSDate *)ac_beginDay;

- (BOOL)ac_isTheSameDayThan:(NSDate *)date;

- (NSInteger)ac_age;
- (NSTimeInterval)ac_timestamp;

@property (readonly) NSInteger ac_seconds;
@property (readonly) NSInteger ac_minute;
@property (readonly) NSInteger ac_hour;
@property (readonly) NSInteger ac_day;
@property (readonly) NSInteger ac_weekday;
@property (readonly) NSInteger ac_month;
@property (readonly) NSInteger ac_year;

- (NSDate *)ac_dateBySeconds:(NSInteger)seconds;
- (NSDate *)ac_dateByMinute:(NSInteger)minute;
- (NSDate *)ac_dateByHour:(NSInteger)hour;
- (NSDate *)ac_dateByDay:(NSInteger)day;
- (NSDate *)ac_dateByWeekDay:(NSInteger)weekday;
- (NSDate *)ac_dateByMonth:(NSInteger)month;
- (NSDate *)ac_dateByYear:(NSInteger)year;
@end
