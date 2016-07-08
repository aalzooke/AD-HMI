//
//  TestController.h
//  AD-HMI
//
//  Created by assam alzookery on 4/20/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tcpSocketChat.h"


@interface TestController : UIViewController<tcpSocketChatDelegate,UITextFieldDelegate>{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSMutableArray *messages;
}
- (IBAction)Disconnect:(id)sender;
- (IBAction)connect:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *chatBox;
@property (weak, nonatomic) IBOutlet UITextView *logView;
- (IBAction)go:(id)sender;
@end
