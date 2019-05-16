//
//  EditCodeView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditCodeView;
@protocol EditCodeViewDelegate <NSObject>
@optional;
- (void)editCodeView:(EditCodeView *)editCodeView inputText:(NSString *)text;
@end
@interface EditCodeView : UIView
@property (nonatomic, weak) id<EditCodeViewDelegate> delegate;
@property (nonatomic, assign) BOOL isEdit;
@end
