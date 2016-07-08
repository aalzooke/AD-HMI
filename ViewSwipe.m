//
//  ViewSwipe.m
//  AD-HMI
//
//  Created by assam alzookery on 4/25/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import "ViewSwipe.h"
#import "View2.h"
#import "GCDAsyncSocket.h"
#import "View1.h"
#import "GCDAsyncSocket.h"



@import Foundation;

@interface ViewSwipe ()
@property (nonatomic,strong) tcpSocketChat *chatSocket;

@end

@implementation ViewSwipe


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
     //[self next];
     View1 *v1 = [[View1 alloc]initWithNibName:@"View1" bundle:nil];
     View2 *v2 = [[View2 alloc]initWithNibName:@"View2" bundle:nil];
    
    
    [self addChildViewController:v1];
    [self.ScrollView addSubview:v1.view];
    [v1 didMoveToParentViewController:self];
    
    [self addChildViewController:v2];
    [self.ScrollView addSubview:v2.view];
    [v2 didMoveToParentViewController:self];
    
    CGRect V2Frame = v2.view.frame;
    V2Frame.origin.x = self.view.frame.size.width;
    v2.view.frame = V2Frame;
    
    self.ScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2 , self.view.frame.size.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)next {
     View2 *controller = [[View2 alloc] initWithNibName:@"View2" bundle:nil];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
   [self presentModalViewController:controller animated:YES];
}
@end
