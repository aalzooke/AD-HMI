//
//  ViewSwipe.h
//  AD-HMI
//
//  Created by assam alzookery on 4/25/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"


// Delegate to return the result
@protocol ViewSwipe
@optional
-(void) TCPSOCKET;
@end


@interface ViewSwipe : UIViewController<tcpSocketChatDelegate,NSStreamDelegate,UITextFieldDelegate,ViewSwipe>
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
    
}
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
@property(nonatomic, assign) id delegate;
-(void) TCPSOCKET;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
- (IBAction)next;

@end
