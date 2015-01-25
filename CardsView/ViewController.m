//
//  ViewController.m
//  CardsView
//
//  Created by khaled El Morabeaa on 1/25/15.
//  Copyright (c) 2015 Brightunit. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()
{
    CircleTableView *Circle_Main;
    int largeRadius;
    int smallRadius;
    NSTimer *timer;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainCirlce];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark  -CircleTableDelegate

-(void)initMainCirlce
{
    Circle_Main=[[CircleTableView alloc]init];
    Circle_Main.frame=CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height-130);
    [Circle_Main setOriginal_color:[UIColor blackColor]];
    [Circle_Main setSelected_color:[UIColor brownColor]];
    largeRadius=170;
    smallRadius=80;
    
    if (IS_IPHONE_6||IS_IPHONE_6_PLUS) {
        largeRadius+=30;
        smallRadius+=10;
        
    }
    else if(IS_IPHONE_4)
    {
        largeRadius-=20;
        smallRadius-=10;
    }
    else if (IS_IPAD)
    {
        largeRadius+=120;
        smallRadius+=70;
    }
    [Circle_Main setStart_Angle:230];
    [Circle_Main setOffSet_Angle:5.0f];
    [Circle_Main setLarge_Raduis:largeRadius];
    [Circle_Main setSmall_Raduis:smallRadius];
    [Circle_Main setRemaining_distance:100];
    [Circle_Main setCornerRaduis:5.0];
    [Circle_Main setDelegate:self];
    //[Circle_Main setDisableRotating:NO];
    [self.view addSubview:Circle_Main];
    
    
    
    [self performSelector:@selector(startanimation) withObject:nil afterDelay:0.4];
    
    
}



-(CardData*)cardForRowAtIndex:(int)index
{
    CardData *card=[[CardData alloc] init];
    card.cardImage=[UIImage imageNamed:@"Home_Icon.png"];
    card.cardName=[NSString stringWithFormat:@"Card No %d",(int)index];
    return card;
}

-(int)noOfCardOfCircleTableView
{
    return 4;
}
-(CGPoint)centerOfCircleTableView
{
    return CGPointMake(150,200);
}
-(void)startanimation
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0/20.0 target:self selector:@selector(nextFrame) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode: NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
}

-(void)nextFrame
{
    [Circle_Main updateValues];
    [Circle_Main setNeedsDisplay];
}

-(void)cardDidSelectAtIndex:(int)Index
{
    float duration=0.5;
    NSString *selecteNo=[NSString stringWithFormat:@"Card No %d",(int)Index];
    [self performSelector:@selector(goToNextView:) withObject:selecteNo afterDelay:duration];
}

-(void)goToNextView:(NSString*)cardNo
{
    [self performSegueWithIdentifier:@"pushCircle" sender:cardNo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushCircle"]) {
        
        [(NextViewController*)segue.destinationViewController setSelectedCardName:(NSString*)sender];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Circle_Main expanCards];
    [Circle_Main reloadDataWithAnimation:NO];
}

@end
