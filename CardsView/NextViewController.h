//
//  NextViewController.h
//  CardsView
//
//  Created by khaled El Morabeaa on 1/25/15.
//  Copyright (c) 2015 Brightunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextViewController : UIViewController
@property (nonatomic,strong) NSString *selectedCardName;
@property (nonatomic,weak) IBOutlet UILabel *selectedCardLBL;

@end

