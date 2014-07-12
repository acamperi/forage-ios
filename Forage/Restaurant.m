//
//  Restaurant.m
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

+ (Restaurant *)parseFromJson:(NSDictionary *)json
{
    Restaurant *restaurant = [[Restaurant alloc] init];
    restaurant.name = json[@"name"];
    restaurant.genre = json[@"genre"];
    restaurant.address = json[@"address"];
    restaurant.latitude = [json[@"latitude"] floatValue];
    restaurant.longitude = [json[@"longitude"] floatValue];
    return restaurant;
}

@end
