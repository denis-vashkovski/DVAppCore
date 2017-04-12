//
//  NSDate+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSDate+AppCore.h"

#import "NSString+AppCore.h"

static const unsigned componentUnits = (NSCalendarUnitYear
                                        | NSCalendarUnitMonth
                                        | NSCalendarUnitDay
                                        | NSCalendarUnitWeekOfMonth
                                        | NSCalendarUnitHour
                                        | NSCalendarUnitMinute
                                        | NSCalendarUnitSecond
                                        | NSCalendarUnitWeekday
                                        | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate(AppCore)

+ (NSCalendar *)ac_currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    return sharedCalendar;
}

+ (NSInteger)ac_currentTimeZone {
    return round([NSTimeZone localTimeZone].secondsFromGMT / AC_HOUR_IN_SECONDS);
}

+ (instancetype)ac_dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:[NSDate date]];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = 0;
    
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

+ (instancetype)ac_dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    return [self ac_dateWithYear:year month:month day:day hour:0 minute:0];
}

+ (instancetype)ac_date:(NSString *)dateString dateFormat:(NSString *)dateFormat timeZoneAbbreviation:(NSString *)timeZoneAbbreviation {
    if (!dateString || dateString.ac_isEmpty ||
        !dateFormat || dateFormat.ac_isEmpty) {
        return nil;
    }
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:dateFormat];
    
    if (timeZoneAbbreviation && !timeZoneAbbreviation.ac_isEmpty) {
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZoneAbbreviation]];
    }
    
    return [df dateFromString:dateString];
}

+ (instancetype)ac_dateUTC:(NSString *)dateString dateFormat:(NSString *)dateFormat {
    return [self ac_date:dateString dateFormat:dateFormat timeZoneAbbreviation:AC_UTC_KEY];
}

+ (instancetype)ac_date:(NSString *)dateString dateFormat:(NSString *)dateFormat {
    return [self ac_date:dateString dateFormat:dateFormat timeZoneAbbreviation:nil];
}

+ (instancetype)ac_dateWithTimestamp:(NSTimeInterval)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:(timestamp / AC_SECOND_IN_MILLISECONDS)];
}

- (NSString *)ac_stringWithFormat:(NSString *)format timeZoneAbbreviation:(NSString *)timeZoneAbbreviation {
    if (!format || format.ac_isEmpty) {
        return nil;
    }
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:format];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:AC_EN_US_POSIX_LOCALE_IDENTIFIER]];
    
    if (timeZoneAbbreviation && !timeZoneAbbreviation.ac_isEmpty) {
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timeZoneAbbreviation]];
    }
    
    return [df stringFromDate:self];
}

- (NSString *)ac_stringWithFormat:(NSString *)format {
    return [self ac_stringWithFormat:format timeZoneAbbreviation:nil];
}

- (NSString *)ac_stringUTCWithFormat:(NSString *)format {
    return [self ac_stringWithFormat:format timeZoneAbbreviation:AC_UTC_KEY];
}

- (BOOL)ac_isWeekend {
    NSCalendar *calendar = [NSDate ac_currentCalendar];
    NSUInteger unit = NSCalendarUnitWeekday;
    
    NSRange weekdayRange = [calendar maximumRangeOfUnit:unit];
    NSUInteger weekdayOfDate = [[calendar components:unit fromDate:self] weekday];
    
    return weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length;
}

- (NSDate *)ac_dateByAddingDay:(int)day {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = day;
    
    NSCalendar *theCalendar = [NSDate ac_currentCalendar];
    return [theCalendar dateByAddingComponents:dayComponent
                                        toDate:self
                                       options:0];
}

- (NSDate *)ac_nextDay {
    return [self ac_dateByAddingDay:1];
}

- (NSDate *)ac_previousDay {
    return [self ac_dateByAddingDay:-1];
}

- (NSDate *)ac_beginDay {
    NSDateComponents *dateComponents = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    
    return [[NSDate ac_currentCalendar] dateFromComponents:dateComponents];
}

- (BOOL)ac_isTheSameDayThan:(NSDate *)date {
    return self.ac_year == date.ac_year && self.ac_month == date.ac_month && self.ac_day == date.ac_day;
}

- (NSInteger)ac_age {
    return [[NSDate ac_currentCalendar] components:componentUnits fromDate:self toDate:[NSDate date] options:0].year;
}

- (NSTimeInterval)ac_timestamp {
    return [self timeIntervalSince1970] * AC_SECOND_IN_MILLISECONDS;
}

- (NSInteger)ac_seconds {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    return components.second;
}

- (NSInteger)ac_minute {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    return components.minute;
}

- (NSInteger)ac_hour {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    return components.hour;
}

- (NSInteger)ac_day {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    return components.day;
}

- (NSInteger)ac_weekday {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    return components.weekday;
}

- (NSInteger)ac_month {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    return components.month;
}

- (NSInteger)ac_year {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    return components.year;
}

- (NSDate *)ac_dateBySeconds:(NSInteger)seconds {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    components.second = seconds;
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

- (NSDate *)ac_dateByMinute:(NSInteger)minute {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    components.minute = minute;
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

- (NSDate *)ac_dateByHour:(NSInteger)hour {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    components.hour = hour;
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

- (NSDate *)ac_dateByDay:(NSInteger)day {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    components.day = day;
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

- (NSDate *)ac_dateByWeekDay:(NSInteger)weekday {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    components.weekday = weekday;
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

- (NSDate *)ac_dateByMonth:(NSInteger)month {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    components.month = month;
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

- (NSDate *)ac_dateByYear:(NSInteger)year {
    NSDateComponents *components = [[NSDate ac_currentCalendar] components:componentUnits fromDate:self];
    components.year = year;
    return [[NSDate ac_currentCalendar] dateFromComponents:components];
}

@end
