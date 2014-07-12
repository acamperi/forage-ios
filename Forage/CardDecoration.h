//
//  CardDecoration.h
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

@interface CardDecoration : NSObject

+ (CardDecoration *)sharedInstance;
- (UIColor *)randomCardBackgroundColor;

@end
