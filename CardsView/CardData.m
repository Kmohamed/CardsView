//
//  CardData.m
//  CircleTableView
//
//  Created by khaled el morabea on 11/11/14.
//  Copyright (c) 2014 Ibtikar. All rights reserved.
//

#import "CardData.h"

@implementation CardData

- (void)addnewData {
    // Do any additional setup after loading the view, typically from a nib.
}

- (instancetype)initWithName:(NSString *)name andImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _cardName = name;
        _cardImage = image;
        _isSelected = NO;
    }
    return self;
}

- (void)resetSelection {
    self.isSelected = NO;
}

- (NSDictionary *)toDictionary {
    return @{
        @"cardName": self.cardName ?: @"",
        @"isSelected": @(self.isSelected)
    };
}

@end
