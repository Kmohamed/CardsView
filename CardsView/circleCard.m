//
//  circleCard.m
//  CircleTableView
//
//  Created by khaled el morabea on 11/5/14.
//  Copyright (c) 2014 Ibtikar. All rights reserved.
//

#import "circleCard.h"

@implementation circleCard


-(id)initWithStartAngle:(CGFloat)startAngle andWidth:(CGFloat)width andLargeRaduis:(CGFloat)largeRaduis andSmallRaduis:(CGFloat)smallRaduis andCardName:(NSString*)cardName andCardIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.width_Angle = width;
        self.large_Raduis = largeRaduis;
        self.small_Raduis=smallRaduis;
        self.cardName=cardName;
        self.start_angle=startAngle;
        self.cardIndex=index;
    }
    return self;

}
@end
