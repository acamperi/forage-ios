//
//  RestaurantCard.m
//  Forage
//
//  Created by Ariel Camperi on 11/7/14.
//  Copyright (c) 2014 Forage. All rights reserved.
//

#import "RestaurantCard.h"
#import "CardDecoration.h"

@implementation RestaurantCard
{
    id <RestaurantCardDelegate> delegate;
    UILabel *genreLabel;
    UIImageView *startNavigationButton;
//    UIControl *startNavigationButton;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<RestaurantCardDelegate>)delegate_
{
    self = [super initWithFrame:frame];
    if (self) {
        delegate = delegate_;
        
        self.backgroundColor = [[CardDecoration sharedInstance] randomCardBackgroundColor];
        genreLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 20., 0.)];
        genreLabel.backgroundColor = [UIColor clearColor];
        genreLabel.textAlignment = NSTextAlignmentCenter;
        genreLabel.textColor = [UIColor whiteColor];
        genreLabel.font = [UIFont systemFontOfSize:60];
        genreLabel.numberOfLines = 0;
        [self addSubview:genreLabel];
        
        startNavigationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go_button"]];
        startNavigationButton.contentMode = UIViewContentModeScaleAspectFit;
        [startNavigationButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startNavigationButtonPressed)]];
        startNavigationButton.userInteractionEnabled = YES;
        [self addSubview:startNavigationButton];
    }
    return self;
}

- (void)setRestaurant:(Restaurant *)restaurant
{
    _restaurant = restaurant;
    genreLabel.text = restaurant.genre;
    [genreLabel sizeToFit];
    genreLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - genreLabel.frame.size.height / 2.);
    startNavigationButton.frame = CGRectMake(0, CGRectGetMidY(self.bounds) + 10, self.bounds.size.width, 100);
}

- (void)startNavigationButtonPressed
{
    [delegate startNavigationForRestaurantCard:self];
}

@end
