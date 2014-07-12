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
    UILabel *nextSuggestionLabel;
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
        genreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.];
        genreLabel.numberOfLines = 0;
        [self addSubview:genreLabel];
        
        startNavigationButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go_button"]];
        startNavigationButton.frame = CGRectMake(0, self.bounds.size.height - 120., self.bounds.size.width, 100.);
        startNavigationButton.contentMode = UIViewContentModeScaleAspectFit;
        [startNavigationButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startNavigationButtonPressed)]];
        startNavigationButton.userInteractionEnabled = YES;
        [self addSubview:startNavigationButton];
        
        nextSuggestionLabel = [[UILabel alloc] init];
        nextSuggestionLabel.backgroundColor = [UIColor clearColor];
        nextSuggestionLabel.textAlignment = NSTextAlignmentCenter;
        nextSuggestionLabel.textColor = [UIColor whiteColor];
        nextSuggestionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.];
        nextSuggestionLabel.text = @"Not tempted? Swipe left to see the next suggestion.";
        nextSuggestionLabel.numberOfLines = 0;
        [self addSubview:nextSuggestionLabel];
    }
    return self;
}

- (void)setRestaurant:(Restaurant *)restaurant
{
    _restaurant = restaurant;
    genreLabel.text = restaurant.genre;
    [genreLabel sizeToFit];
    genreLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - 30.);
    nextSuggestionLabel.frame = CGRectMake(0., CGRectGetMaxY(genreLabel.frame) + 10., self.bounds.size.width, 40.);
}

- (void)startNavigationButtonPressed
{
    [delegate startNavigationForRestaurantCard:self];
}

@end
