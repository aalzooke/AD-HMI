//
//  TestController 2.h
//  AD-HMI
//
//  Created by assam alzookery on 4/22/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"


@interface TestController_2 : UIViewController<tcpSocketChatDelegate,NSStreamDelegate>{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
}
- (IBAction)disconnect:(id)sender;

- (IBAction)connect:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *logView;
@end
