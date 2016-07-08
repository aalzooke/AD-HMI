//
//  View2.h
//  AD-HMI
//
//  Created by assam alzookery on 4/25/16.
//  Copyright © 2016 assam alzookery. All rights reserved.q
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"


@interface View2 : UIViewController<tcpSocketChatDelegate,UITextFieldDelegate,NSStreamDelegate>
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
-(void)TCP;
- (IBAction)SendButton;
@end
