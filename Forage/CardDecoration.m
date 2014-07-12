//
//  CardDecoration.m
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "CardDecoration.h"

@interface CardDecoration ()

@property (strong, nonatomic) NSArray *possibleBackgroundColors;

@end

@implementation CardDecoration

+ (CardDecoration *)sharedInstance
{
    static CardDecoration *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CardDecoration alloc] init];
        instance.possibleBackgroundColors = @[[UIColor colorWithRed:0.016 green:0.196 blue:0.071 alpha:1],
                                              [UIColor colorWithRed:0.149 green:0.02 blue:0.204 alpha:1],
                                              [UIColor colorWithRed:0.059 green:0.235 blue:0.529 alpha:1],
                                              [UIColor colorWithRed:0.545 green:0.541 blue:0.161 alpha:1],
                                              [UIColor colorWithRed:0.435 green:0.098 blue:0.071 alpha:1],
                                              [UIColor colorWithRed:0.392 green:0.357 blue:0.353 alpha:1]];
//                                              [UIColor colorWithRed:0.553 green:0.220 blue:0.784 alpha:1.000],
//                                              [UIColor colorWithRed:1.000 green:0.138 blue:0.157 alpha:1.000],
//                                              [UIColor colorWithRed:0.478 green:0.000 blue:1.000 alpha:1.000],
//                                              [UIColor colorWithRed:0.000 green:0.837 blue:1.000 alpha:1.000],
//                                              [UIColor colorWithRed:1.000 green:0.520 blue:0.000 alpha:1.000],
//                                              [UIColor colorWithRed:0.739 green:1.000 blue:0.000 alpha:1.000],
//                                              [UIColor colorWithRed:0.000 green:1.000 blue:0.242 alpha:1.000]];
    });
    return instance;
}

- (UIColor *)randomCardBackgroundColor
{
    return (UIColor *)self.possibleBackgroundColors[arc4random_uniform((u_int32_t)self.possibleBackgroundColors.count)];
}

@end
