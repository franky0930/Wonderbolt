//
//  WBUtilities.h
//  Wonderbolt
//
// 
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#ifndef Wonderbolt_WBUtilities_h
#define Wonderbolt_WBUtilities_h

// System

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

// Notifications

#define WB_NOTIFY(__KEY__) [[NSNotificationCenter defaultCenter] postNotificationName:__KEY__ object:nil]
#define WB_NOTIFY_WITH_OBJ(__KEY__,__OBJ__) [[NSNotificationCenter defaultCenter] postNotificationName:__KEY__ object:nil userInfo:__OBJ__]

//#define WB_UI_NOTIFY(__MSG__)  [TSMessage showNotificationWithTitle:__MSG__ type:TSMessageNotificationTypeMessage];
//#define WB_UI_NOTIFY_SUCCESS(__MSG__)  [TSMessage showNotificationWithTitle:__MSG__ type:TSMessageNotificationTypeSuccess];
//#define WB_UI_NOTIFY_WARNING(__MSG__)  [TSMessage showNotificationWithTitle:__MSG__ type:TSMessageNotificationTypeWarning];
//#define WB_UI_NOTIFY_ERROR(__MSG__)  [TSMessage showNotificationWithTitle:__MSG__ type:TSMessageNotificationTypeError];

// HUD

//#define WB_HUD_SETUP_FONT(__FONT__,__SIZE__) [[SVProgressHUD appearance] setHudFont:[UIFont fontWithName:__FONT__ size:__SIZE__]]
//#define WB_HUD_MASKED(__MSG__) [SVProgressHUD showWithStatus:__MSG__ maskType:SVProgressHUDMaskTypeGradient]
//#define WB_HUD_SUCCESS(__MSG__) [SVProgressHUD showSuccessWithStatus:__MSG__]
//#define WB_HUD_ERROR(__MSG__) [SVProgressHUD showErrorWithStatus:__MSG__]
//#define WB_HUD_DISMISS() [SVProgressHUD dismiss]

// User Defaults

#define WB_USER_SAVE() [[NSUserDefaults standardUserDefaults] synchronize]

#define WB_USER_GET(__KEY__) [[NSUserDefaults standardUserDefaults] valueForKey:__KEY__]
#define WB_USER_SET(__KEY__,__VALUE__,__SYNC__) ({[[NSUserDefaults standardUserDefaults] setValue:__VALUE__ forKey:__KEY__]; if(__SYNC__) WB_USER_SAVE();})

#define WB_USER_GET_S(__KEY__) [[NSUserDefaults standardUserDefaults] stringForKey:__KEY__]
#define WB_USER_SET_S(__KEY__,__VALUE__,__SYNC__) ({[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__]; if(__SYNC__) WB_USER_SAVE();})

#define WB_USER_GET_B(__KEY__) [[NSUserDefaults standardUserDefaults] boolForKey:__KEY__]
#define WB_USER_SET_B(__KEY__,__VALUE__,__SYNC__) ({[[NSUserDefaults standardUserDefaults] setBool:__VALUE__ forKey:__KEY__]; if(__SYNC__) WB_USER_SAVE();})

#define WB_USER_GET_I(__KEY__) [[NSUserDefaults standardUserDefaults] integerForKey:__KEY__]
#define WB_USER_SET_I(__KEY__,__VALUE__,__SYNC__) ({[[NSUserDefaults standardUserDefaults] setInteger:__VALUE__ forKey:__KEY__]; if(__SYNC__) WB_USER_SAVE();})

#define WB_USER_GET_F(__KEY__) [[NSUserDefaults standardUserDefaults] floatForKey:__KEY__]
#define WB_USER_SET_F(__KEY__,__VALUE__,__SYNC__) ({[[NSUserDefaults standardUserDefaults] setFloat:__VALUE__ forKey:__KEY__]; if(__SYNC__) WB_USER_SAVE();})

// Color

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// Localization

#define WB_TR(__STR__) NSLocalizedString(__STR__, nil)

#endif
