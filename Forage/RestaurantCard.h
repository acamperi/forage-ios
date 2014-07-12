//
//  RestaurantCard.h
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "Restaurant.h"

@class RestaurantCard;

@protocol RestaurantCardDelegate

- (void)startNavigationForRestaurantCard:(RestaurantCard *)restaurantCard;

@end

@interface RestaurantCard : UIControl

@property (strong, nonatomic) Restaurant *restaurant;

- (id)initWithFrame:(CGRect)frame delegate:(id<RestaurantCardDelegate>)delegate_;

@end
