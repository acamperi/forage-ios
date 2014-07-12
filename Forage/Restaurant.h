//
//  Restaurant.h
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

@interface Restaurant : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

+ (Restaurant *)parseFromJson:(NSDictionary *)json;

@end
